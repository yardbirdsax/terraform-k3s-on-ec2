data aws_ami "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource random_string agent_token { 
  length = 24
  special = false
}

resource aws_key_pair k3s_keypair {
  key_name = var.deployment_name
  public_key = var.keypair_path == "" ? var.keypair_content : file(var.keypair_path)
}

resource aws_iam_instance_profile instance_profile {
  name = "${var.deployment_name}-InstanceProfile"
  role = var.iam_role_name
  count = var.iam_role_name == null ? 0 : 1
}

data cloudinit_config "userData" {
  part {
    content = <<EOF
#cloud-config
---
hostname: "${var.deployment_name}"
EOF
    content_type = "text/cloud-config"
  }
  
  part {
    content = <<EOF
#!/bin/bash
curl -sfL https://get.k3s.io | K3S_TOKEN=${random_string.agent_token.result} sh - 
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

  part {
    content = <<EOF
#!/bin/bash
apt-get update && \
apt-get install ec2-instance-connect -y
EOF
    content_type = "text/x-shellscript"
  }
}

resource aws_instance k3s_instance {
  ami = data.aws_ami.ubuntu.id
  associate_public_ip_address = var.assign_public_ip
  instance_type = var.instance_type
  key_name = aws_key_pair.k3s_keypair.key_name
  iam_instance_profile = var.iam_role_name == null ? null : aws_iam_instance_profile.instance_profile[0].name
  subnet_id = var.subnet_id == "" ? "" : var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  user_data = data.cloudinit_config.userData.rendered
}

output instance {
    value = aws_instance.k3s_instance
}