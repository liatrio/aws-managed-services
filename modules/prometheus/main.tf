provider "aws" {
  region = "us-east-1"
  alias  = "billing_region"
}

locals {
  name     = "aws-observability-accelerator-cloudwatch"
  #amp_list = toset(split(",", var.managed_prometheus_workspace_ids))
  amp_list = var.managed_prometheus_workspace_ids
  iam_role_name = "aws-observability-workspace-iam-role"
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = local.name

  # Giving priority to Managed Prometheus datasources
  is_default = false
  json_data {
    default_region  = var.aws_region
    sigv4_auth      = true
    sigv4_auth_type = local.iam_role_name
    sigv4_region    = var.aws_region
  }
}

resource "grafana_dashboard" "this" {
  folder      = var.dashboards_folder_id
  config_json = file("${path.module}/dashboards/amp-dashboard.json")
}

module "billing" {
  source = "./billing"
  providers = {
    aws = aws.billing_region
  }
}
