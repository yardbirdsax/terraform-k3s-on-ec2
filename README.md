# k3s on EC2 with Terraform

This is a [Terraform](https://terraform.io) module that will provision a single node [k3s](https://k3s.io) cluster using AWS EC2 instances.

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
## Worker-Node Autoscaling Group Feature

Currently the module allows for the provisioning of a separate autoscaling group for worker (non master) nodes. This is a new feature and has the following caveats / limitations:

* The worker-node instances will be placed in the same subnet as the master node. Deployments in multiple subnets are not currently possible.
* The worker-node instances will be assigned to the same security group(s) as the master node.
* The worker-node instances will be assigned to the same instance profile as the master node.
* The worker-node instances will be the same Instance Type as the master node.
* The worker-node instances will be assigned public IPs if the master node is.

It is the intention to enhance the module over time to allow more granular control of the worker nodes, such as assigning different Instance Profiles, multiple subnets, etc.

>**Please keep a close watch on the [Change Log](changelog.md) file as versions are published, as behavior may change over time. Effort will be made to keep key functionality the same as much as possible.**
