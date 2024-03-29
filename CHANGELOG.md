# 1.0

- The AWS provider is no longer declared in the module. Instead, you should declare a provider in your calling deployment, and pass it in to the module as illustrated [here](https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly).
- **BREAKING CHANGE** The `aws_region` input variable is removed. Since the AWS provider is no longer explicitly declared, the deployment will occur in whatever region is configured on the provider passed in to the module.
- A new variable has been added, `keypair_content`, allowing passing in the public key pair data directly rather than by filename. The original `keypair_path` variable remains but has been made optional. One or the other must be specified.
- **BREAKING CHANGE** The `keypair_path` variable no longer defaults to `~/.ssh/id_pub.rsa`. Instead, it is a blank string and will not be used if left that way. You must explicitly specify the path if it is to be used.
- **BREAKING CHANGE** The `security_group_ids` variable is no longer optional. You must now specify the specific security groups that you wish the master instance to be added to. This corrects a bug where you could run the deployment initially and it would succeed, but subsequent ones would fail, if the instance was deployed in the default VPC.

# 1.1

- [EC2 Instance Connect](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Connect-using-EC2-Instance-Connect.html) is now installed on the Master node.
- By setting the value of the new `enable_worker_nodes` variable to `true`, a separate Auto-Scaling Group will be provisioned that will house worker nodes. **This functionality is very new and has numerous limitations. Please make sure you read the appropriate section of the [Readme file](README.md#Worker-Node-Autoscaling-Group-Feature) for details.**

# 1.2

- Previously when an empty string was provided for the `iam_role_name` variable, or the variable was not specified, the IAM Instance Profile resource for the agent nodes would be modified on every apply by creating an empty `iam_instance_profile` block. Now the value of the variable defaults to `null` instead of an empty string, and the resource is not modified on every commit. **If the value is manually given as an empty string, the issue will persist.**

# 1.3
- The `worker_node_desired_count` variable now defaults to a value of `0`. Previously, it did not have a default, so deployments would fail where it was not specified.
- All `template_cloudinit_config` resources have been replaced with `cloudinit_config` since the former is now deprecated.
- A new variable is introduced called `kubeconfig_write`, which allows you to specify the file mode used when writing the `kubeconfig` file on the master instance.

# Unreleased
- You are now able to specify an AMI ID which will override the base image selected (the latest Ubuntu Server).
- If you do not specify a value for either the `keypair_content` nor `keypair_path` variables, no AWS keypair is created or used for the provisioned instances.