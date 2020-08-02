# k3s on EC2 with Terraform

This is a [Terraform](https://terraform.io) module that will provision a single node [k3s](https://k3s.io) cluster using AWS EC2 instances.

## Variables

| Variable Name         | Description                                                                   |
------------------------|-------------------------------------------------------------------------------|
| keypair_path          | The path to the SSH public key file that will be used for access to the instances. If this is specified, the value of `keypair_content` is ignored. |
| keypair_content          | The content to be used for creating the SSH public key for the instances. If this is specified, `keypair_path` must not be. |
| deployment_name       | A unique name used to generate things like the instance names.                 |
| iam_role_name         | The name of an existing IAM role to assign to the instance profiles. If left blank, no role will be assigned. |
| subnet_id             | The ID of the subnet where the instances will be provisioned. If left blank, it will be provisioned in the default subnet of the default VPC. |
| security_group_ids    | A list of IDs of Security Groups that the instances should be assigned to.     |
| assign_public_ip      | If set to `true`, the instances will be assigned a public IP. Defaults to `true`. |
| instance_type         | The AWS [Instance Type](https://aws.amazon.com/ec2/instance-types/) to use when provisioning the instances. Defaults to 't3.small'. |
| manifest_bucket_path  | The AWS S3 bucket name and path that will be used to download manifest files for auto-installation as per [this documentation](https://rancher.com/docs/k3s/latest/en/advanced/). Should be specified as 'bucket name/folder name/'. The IAM Role assigned to the instance must have GetObject access to this bucket. |
| enable_worker_nodes   | If set to `true`, a separate autoscaling group will be provisioned for worker nodes. Defaults to `false`.
| worker_node_min_count | The minimum number of instances to provision for the worker node autoscaling group.
| worker_node_max_count | The maximum number of instances to provision for the worker node autoscaling group.
| worker_node_desired_count | The desired number of instances to provision for the worker node autoscaling group.

## Worker-Node Autoscaling Group Feature

Currently the module allows for the provisioning of a separate autoscaling group for worker (non master) nodes. This is a new feature and has the following caveats / limitations:

* The worker-node instances will be placed in the same subnet as the master node. Deployments in multiple subnets are not currently possible.
* The worker-node instances will be assigned to the same security group(s) as the master node.
* The worker-node instances will be assigned to the same instance profile as the master node.
* The worker-node instances will be the same Instance Type as the master node.
* The worker-node instances will be assigned public IPs if the master node is.

It is the intention to enhance the module over time to allow more granular control of the worker nodes, such as assigning different Instance Profiles, multiple subnets, etc.

>**Please keep a close watch on the [Change Log](changelog.md) file as versions are published, as behavior may change over time. Effort will be made to keep key functionality the same as much as possible.**
