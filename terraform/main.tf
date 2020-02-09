provider aws {
    region = var.aws_region
}

data aws_ami "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource aws_key_pair k3s_keypair {
  key_name = var.deployment_name
  public_key = file(var.keypair_path)
}

resource aws_iam_instance_profile instance_profile {
  name = "${var.deployment_name}-InstanceProfile"
  role = var.iam_role_name
  count = var.iam_role_name == "" ? 0 : 1
}

data template_cloudinit_config "userData" {
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
curl -sfL https://get.k3s.io | sh -
apt-get update && \
apt-get install awscli
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

resource aws_instance k3s_instance {
  ami = data.aws_ami.ubuntu.id
  associate_public_ip_address = var.assign_public_ip
  instance_type = var.instance_type
  key_name = aws_key_pair.k3s_keypair.key_name
  iam_instance_profile = var.iam_role_name == "" ? "" : aws_iam_instance_profile.instance_profile[0].name
  subnet_id = var.subnet_id == "" ? "" : var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  user_data = data.template_cloudinit_config.userData.rendered
}

output instance {
    value = aws_instance.k3s_instance
}