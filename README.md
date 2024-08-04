# Virtual Private Clouds on AWS

This project contains  [Terraform](https://www.terraform.io/) configuration that creates
a functional [VPC](https://aws.amazon.com/vpc/) in
an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

For more information, please visit the blog
post [Virtual Private Clouds on AWS ](https://example.com).

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* (Optional) Have [Terragrunt](https://terragrunt.gruntwork.io) installed if you want to store the
  state of your infrastructure in S3 buckets instead of your local computer.

Please note that this code was written for Terraform versions >= 1.2 and <= 1.5.6.

## Project structure

The project contains two options for creating a VPC:

1. [Elaborative](elaborative); This option lists down the step-by-step process of
   creating a VPC highlighting all the important aspects.
2. [terraform-aws-module](terraform-aws-modules); This option utilises [Terraform AWS
   Modules](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) to create a
   VPC. This is an ideal option once you understand the concepts around VPCs in AWS.
