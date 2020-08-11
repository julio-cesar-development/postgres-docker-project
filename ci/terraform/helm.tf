resource "helm_release" "postgres-project" {
  name             = "postgres-project"
  chart            = "${path.root}/../charts/"
  namespace        = var.release_namespace
  create_namespace = true
  timeout          = 300
  wait             = true
  lint             = true
  force_update     = true
  replace          = true

  version = "0.1.0"

  values = [
    file("${path.root}/../charts/values.yaml")
  ]

  set {
    name  = "api.image.tag"
    value = var.image_api_tag
    type  = "string"
  }

  set {
    name  = "postgres.image.tag"
    value = var.image_postgres_tag
    type  = "string"
  }

  set {
    name  = "fluentd.image.tag"
    value = var.image_fluentd_tag
    type  = "string"
  }

  set_sensitive {
    name  = "postgres.secrets.postgresUser"
    value = var.postgres_user
    type  = "string"
  }

  set_sensitive {
    name  = "postgres.secrets.postgresPassword"
    value = var.postgres_password
    type  = "string"
  }
}
