# k3s on EC2 with Terraform

This is a [Terraform](https://terraform.io) module that will provision a single node [k3s](https://k3s.io) cluster using AWS EC2 instances.

## Variables

| Variable Name         | Description                                                                   |
------------------------|-------------------------------------------------------------------------------|
| aws_region            | The AWS Region where resources will be deployed. Defaults to 'us-east-2'.     |
| keypair_path          | The path to the SSH public key file that will be used for access to the instance. |
| deployment_name       | A unique name used to generate things like the instance name.                 |
| iam_role_name         | The name of an existing IAM role to assign to the instance profile. If left blank, no role will be assigned. |
| subnet_id             | The ID of the subnet where the instance will be provisioned. If left blank, it will be provisioned in the default subnet of the default VPC. |
| security_group_ids    | A list of IDs of Security Groups that the instance should be assigned to.     |
| assign_public_ip      | If set to 'true', the instance will be assigned a public IP. Defaults to 'true'. |
| instance_type         | The AWS [Instance Type](https://aws.amazon.com/ec2/instance-types/) to use when provisioning the instance. Defaults to 't3.small'. |
| manifest_bucket_path  | The AWS S3 bucket name and path that will be used to download manifest files for auto-installation as per [this documentation](https://rancher.com/docs/k3s/latest/en/advanced/). Should be specified as 'bucket name/folder name/'. The IAM Role assigned to the instance must have GetObject access to this bucket. |
