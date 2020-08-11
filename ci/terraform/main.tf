terraform {
  required_version = "~> 0.12.0"

  required_providers {
    aws        = "~> 3.1.0"
    kubernetes = "~> 1.12.0"
    helm       = "~> 1.2.4"
  }

  # TODO: enable backend
  # backend "s3" {
  #   bucket = "blackdevs-aws"
  #   key    = "terraform/postgres-project/state.tfstate"
  #   region = "sa-east-1"
  # }
}
