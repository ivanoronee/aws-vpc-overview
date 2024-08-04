# Virtual Private Clouds on AWS

This folder contains  [Terraform](https://www.terraform.io/) configuration that
creates an [VPC](https://aws.amazon.com/vpc/) in
an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

For more info, please see the blog post [Virtual Private Clouds on AWS ](https://example.com).

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* (Optional) [Terragrunt](https://terragrunt.gruntwork.io) if you want to store the state of your
  infrastructure in S3 buckets instead of your local computer.

Please note that this code was written for Terraform versions >= 1.2 and <= 1.5.6.

## Quick start

**Please note that this example will deploy real resources into your AWS account. Careful
consideration has been taken to ensure that all resources qualify for
the [AWS Free Tier](https://aws.amazon.com/free/), but I am not responsible for any charges you may
incur.**

Configure your [AWS access
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)
as environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

### Configure S3 backend (Optional)

For production grade infrastructure, use S3 to store Terraform infrastructure state files. Skip
this step if you would rather store the state files on your local computer — which is fine for
this demo.

```shell
export TF_STATE_S3_BUCKET=<name of your S3 bucket>
export TF_STATE_REGION=<name of your AWS region>
export TF_STATE_DYNAMODB_TABLE=<name of your Dynamo table>

terragrunt plan
```

### Create your VPC

```
# Optionally set the region to use. Default is eu-west-2
export TF_VAR_aws_region="eu-west-2"

# Initialize Terraform
terraform init

# Create specified resources
terraform apply
```

### Clean up

This will delete all the resources created by this code.

**Note:** If you configured an S3 backend, the S3 bucket and Dynamo table will not be deleted.

```
# Set the region to use if changed changed from default eu-west-2
export TF_VAR_aws_region="eu-west-2"

terraform destroy
```
