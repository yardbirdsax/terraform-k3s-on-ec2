# 1.0

- The AWS provider is no longer declared in the module. Instead, you should declare a provider in your calling deployment, and pass it in to the module as illustrated [here](https://www.terraform.io/docs/configuration/modules.html#passing-providers-explicitly).
- **BREAKING CHANGE** The `aws_region` input variable is removed. Since the AWS provider is no longer explicitly declared, the deployment will occur in whatever region is configured on the provider passed in to the module.
- A new variable has been added, `keypair_content`, allowing passing in the public key pair data directly rather than by filename. The original `keypair_path` variable remains but has been made optional. One or the other must be specified.
- **BREAKING CHANGE** The `keypair_path` variable no longer defaults to `~/.ssh/id_pub.rsa`. Instead, it is a blank string and will not be used if left that way. You must explicitly specify the path if it is to be used.
- **BREAKING CHANGE** The `security_group_ids` variable is no longer optional. You must now specify the specific security groups that you wish the master instance to be added to. This corrects a bug where you could run the deployment initially and it would succeed, but subsequent ones would fail, if the instance was deployed in the default VPC.

# Un-released

- [EC2 Instance Connect](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Connect-using-EC2-Instance-Connect.html) is now installed on the Master node.
- By setting the value of the new `enable_worker_nodes` variable to `true`, a separate Auto-Scaling Group will be provisioned that will house worker nodes. **This functionality is very new and has numerous limitations. Please make sure you read the appropriate section of the [Readme file](README.md#Worker-Node-Autoscaling-Group-Feature) for details.**