# AWS variables
variable "aws_access_key" {
  type        = string
  description = "AWS access key ID"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret access Key"
}

variable "aws_hosted_zone_id" {
  type        = string
  description = "AWS hosted zone ID"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "sa-east-1"
}

# miscellaneous
variable "image_api_tag" {
  type        = string
  description = "Image tag for API"
  default     = "latest"
}

variable "image_postgres_tag" {
  type        = string
  description = "Image tag for Postgres"
  default     = "9.6-alpine"
}

variable "image_fluentd_tag" {
  type        = string
  description = "Image tag for Fluentd"
  default     = "v2.5.2"
}

variable "release_namespace" {
  type        = string
  description = "K8S namespace for Release"
  default     = "default"
}

variable "kubeconfig_path" {
  type        = string
  description = "K8S path of Kubeconfig"
  default     = "~/.kube/config"
}

variable "postgres_user" {
  type        = string
  description = "Postgres user"
}

variable "postgres_password" {
  type        = string
  description = "Postgres password"
}
