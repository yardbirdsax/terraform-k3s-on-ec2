variable aws_region {
    type = string
    default = "us-east-2"
}

variable keypair_path {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable deployment_name {
    type = string
    default = "k3s"
    description = "A unique name used to generate other names for resources, such as instance names."
}

variable iam_role_name {
    type = string
    default = ""
    description = "The name of an IAM Role to assign to the instance. If left blank, no role will be assigned."
}

variable subnet_id {
    type = string
    default = ""
    description = "The ID of a VPC subnet to assign the instance to. If left blank, the instance will be provisioned in the default subnet of the default VPC."
}

variable security_group_ids {
    type = list(string)
    default = ["default"]
    description = "A list of Security Group IDs to assign to the instance. If left blank, none will be assigned."
}

variable assign_public_ip {
    type = bool
    default = true
    description = "If set to 'true', a public IP address will be assigned to the instance."
}

variable instance_type {
    type = string
    default = "t3.small"
    description = "The AWS EC2 Instance Type to provision the instance as."
}

variable manifest_bucket_path {
    type = string
    default = ""
    description = "The AWS S3 bucket name and path that will be used to download manifest files for auto-installation as per [this documentation](https://rancher.com/docs/k3s/latest/en/advanced/). Should be specified as 'bucket name/folder name/'. The IAM Role assigned to the instance must have GetObject access to this bucket."
}