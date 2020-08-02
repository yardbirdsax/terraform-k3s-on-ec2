data template_cloudinit_config "agent_user_data" {
  part {
    content = <<EOF
#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${random_string.agent_token.result} K3S_URL=https://${aws_instance.k3s_instance.public_dns}:6443 sh - 
apt-get update && \
apt-get install awscli -y
EOF
    content_type = "text/x-shellscript"
  }
  
  part {
    content = var.manifest_bucket_path == "" ? "" : <<EOF
#!/bin/bash
aws s3 sync s3://${var.manifest_bucket_path} /var/lib/rancher/k3s/server/manifests/
EOF
  content_type = "text/x-shellscript"  
  }
}

resource aws_launch_template agent_launch_template {
  name = "${var.deployment_name}-agent"
  iam_instance_profile {
    name = var.iam_role_name == "" ? "" : aws_iam_instance_profile.instance_profile[0].name
  }
  image_id = data.aws_ami.ubuntu.image_id
  instance_type = var.instance_type
  key_name = aws_key_pair.k3s_keypair.key_name
  vpc_security_group_ids = var.security_group_ids
  user_data = data.template_cloudinit_config.agent_user_data.rendered
}

resource aws_autoscaling_group agent_autoscaling_group { 
  name = "${var.deployment_name}-agent"
  min_size = var.enable_worker_nodes == true ? var.worker_node_min_count : 0
  max_size = var.enable_worker_nodes == true ? var.worker_node_max_count : 0
  desired_capacity = var.enable_worker_nodes == true ? var.worker_node_desired_count : 0
  launch_template {
    id = aws_launch_template.agent_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_instance.k3s_instance.subnet_id]
}