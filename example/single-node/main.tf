provider "aws" {
  region = "us-east-2"
}

locals {
  deployment_name = "josh-test"
}

data "aws_vpc" "vpc" {
  default = true
}

resource "aws_security_group" "sg" {
  name   = "allow_all"
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "allow_all_inbound" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  type              = "ingress"
  protocol          = "-1"
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  type              = "egress"
  protocol          = "-1"
  security_group_id = aws_security_group.sg.id
}

module "ssh_key_pair" {
  # tflint-ignore: terraform_module_pinned_source
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  namespace             = local.deployment_name
  stage                 = "prod"
  name                  = "k3s"
  ssh_public_key_path   = "~/.ssh"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

module "k3s" {
  source = "../../"
  providers = {
    aws = aws
  }

  assign_public_ip   = true
  deployment_name    = "jef-test"
  instance_type      = "t3a.small"
  keypair_content    = module.ssh_key_pair.public_key
  security_group_ids = [aws_security_group.sg.id]
  kubeconfig_mode    = "644"

}

output "k3s_master_public_dns" {
  value = module.k3s.instance.public_dns
}