remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = get_env("TF_STATE_S3_BUCKET", "explores.orone.aws-vpc")
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = get_env("TF_STATE_REGION", "eu-west-3")
    encrypt        = true
    dynamodb_table = get_env("TF_STATE_DYNAMODB_TABLE", "expores-orone-tf-state-locks")
  }
}
