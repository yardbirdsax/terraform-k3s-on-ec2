# k3s on EC2 with Terraform

This is a [Terraform](https://terraform.io) module that will provision a single node [k3s](https://k3s.io) cluster using AWS EC2 instances.

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.agent_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_instance.k3s_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.k3s_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_template.agent_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [random_string.agent_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [cloudinit_config.agent_user_data](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [cloudinit_config.userData](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | The AMI ID to use when provisioning the instance. If left at the default null value, the latest Ubuntu server image is used. | `string` | `null` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | If set to 'true', a public IP address will be assigned to the instance. | `bool` | `true` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | A unique name used to generate other names for resources, such as instance names. | `string` | `"k3s"` | no |
| <a name="input_enable_worker_nodes"></a> [enable\_worker\_nodes](#input\_enable\_worker\_nodes) | If set to 'true', a separate autoscaling group will be created for worker nodes. | `bool` | `false` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of an IAM Role to assign to the instance. If left blank, no role will be assigned. | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The AWS EC2 Instance Type to provision the instance as. | `string` | `"t3.small"` | no |
| <a name="input_keypair_content"></a> [keypair\_content](#input\_keypair\_content) | The raw data to be used for the public key for the instance. If this is used, no value must be specified for 'keypair\_path'. | `string` | `""` | no |
| <a name="input_keypair_path"></a> [keypair\_path](#input\_keypair\_path) | The path to the public key to use for the instance. | `string` | `""` | no |
| <a name="input_kubeconfig_mode"></a> [kubeconfig\_mode](#input\_kubeconfig\_mode) | Sets the file mode of the generated KUBECONFIG file on the master k3s instance. Defaults to '600'. | `string` | `"600"` | no |
| <a name="input_manifest_bucket_path"></a> [manifest\_bucket\_path](#input\_manifest\_bucket\_path) | The AWS S3 bucket name and path that will be used to download manifest files for auto-installation as per [this documentation](https://rancher.com/docs/k3s/latest/en/advanced/). Should be specified as 'bucket name/folder name/'. The IAM Role assigned to the instance must have GetObject access to this bucket. | `string` | `""` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of Security Group IDs to assign to the instance. | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The ID of a VPC subnet to assign the instance to. If left blank, the instance will be provisioned in the default subnet of the default VPC. | `string` | `""` | no |
| <a name="input_worker_node_desired_count"></a> [worker\_node\_desired\_count](#input\_worker\_node\_desired\_count) | The desired number of worker nodes to provision. | `number` | `0` | no |
| <a name="input_worker_node_max_count"></a> [worker\_node\_max\_count](#input\_worker\_node\_max\_count) | The maximum number of worker node instances to provsion. | `number` | `0` | no |
| <a name="input_worker_node_min_count"></a> [worker\_node\_min\_count](#input\_worker\_node\_min\_count) | The minimum number of worker node instances to provision. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance"></a> [instance](#output\_instance) | n/a |

<!--- END_TF_DOCS --->
## Worker-Node Autoscaling Group Feature

Currently the module allows for the provisioning of a separate autoscaling group for worker (non master) nodes. This is a new feature and has the following caveats / limitations:

* The worker-node instances will be placed in the same subnet as the master node. Deployments in multiple subnets are not currently possible.
* The worker-node instances will be assigned to the same security group(s) as the master node.
* The worker-node instances will be assigned to the same instance profile as the master node.
* The worker-node instances will be the same Instance Type as the master node.
* The worker-node instances will be assigned public IPs if the master node is.

It is the intention to enhance the module over time to allow more granular control of the worker nodes, such as assigning different Instance Profiles, multiple subnets, etc.

>**Please keep a close watch on the [Change Log](changelog.md) file as versions are published, as behavior may change over time. Effort will be made to keep key functionality the same as much as possible.**
