//TODO: Move the grafana module in the `modules/grafana` folder

locals {
  #name        = local.locals_vars.locals.name
  description = "Amazon Managed Grafana workspace for ${local.name}"


  tags = {
    GithubRepo = "terraform-aws-observability-accelerator"
    GithubOrg  = "aws-observability"
  }
  grafana_iam_role_name = module.managed_grafana.workspace_iam_role_name
  iam_role_name = "aws-observability-workspace-iam-role"
}


resource "aws_prometheus_workspace" "this" {
  count = var.enable_managed_prometheus ? 1 : 0

  alias = local.name
  tags  = var.tags
}

resource "aws_prometheus_alert_manager_definition" "this" {
  count = var.enable_alertmanager ? 1 : 0

  workspace_id = local.amp_ws_id

  definition = <<EOF
alertmanager_config: |
    route:
      receiver: 'default'
    receivers:
      - name: 'default'
EOF
}
# TODO: Tweak permissions to be least privileged.
provider "grafana" {
  url  = local.amg_ws_endpoint
  auth = module.managed_grafana.workspace_api_keys["admin"].key
}

resource "grafana_data_source" "amp" {
  count      = var.create_prometheus_data_source ? 1 : 0
  type       = "prometheus"
  name       = local.name
  is_default = true
  url        = local.amp_ws_endpoint
  json_data {
    http_method     = "GET"
    sigv4_auth      = true
    sigv4_auth_type = local.iam_role_name
    sigv4_region    = local.amp_ws_region
  }
}

#dashboards
resource "grafana_folder" "this" {
  count = var.create_dashboard_folder ? 1 : 0
  title = "Observability Accelerator Dashboards"
}

module "managed_prometheus" {
  source = "./modules/prometheus"
  #version = "0.0.1"

  aws_region                      = local.amp_ws_region
  dashboards_folder_id            = grafana_folder.this[0].id
  managed_prometheus_workspace_ids = aws_prometheus_workspace.this[0].id
  active_series_threshold         = 100000
  ingestion_rate_threshold        = 70000
}

# fetch user (could also be a group https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group)
# the instance has to be fetched first and it doesn't require any arguments
# data "aws_ssoadmin_instances" "instances" {}
# data "aws_identitystore_user" "user" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.instances.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "UserName"
#       attribute_value = "o11yTestUser" #TODO: Change this to be a variable
#     }
#   }
# }

module "managed_grafana" {
  source  = "terraform-aws-modules/managed-service-grafana/aws"
  #version = "1.8.0"

  name                      = local.name
  associate_license         = false
  description               = local.description
  account_access_type       = "CURRENT_ACCOUNT"
  authentication_providers  = ["AWS_SSO"]
  permission_type           = "SERVICE_MANAGED"
  data_sources              = ["CLOUDWATCH", "PROMETHEUS", "XRAY"]
  notification_destinations = ["SNS"]
  stack_set_name            = local.name
  create                    = var.create
  create_workspace          = var.create_workspace

  # Workspace API keys
  workspace_api_keys = {
    # viewer = {
    #   key_name        = "viewer"
    #   key_role        = "VIEWER"
    #   seconds_to_live = 3600
    # }
    # editor = {
    #   key_name        = "editor"
    #   key_role        = "EDITOR"
    #   seconds_to_live = 3600
    # }
    admin = {
      key_name        = "admin"
      key_role        = "ADMIN"
      seconds_to_live = 2592000
    }
  }

  configuration = jsonencode({
    unifiedAlerting = {
      enabled = true
    }
  })

  # role_associations = {
  #   "ADMIN" = {
  #     "user_ids" = [data.aws_identitystore_user.user.user_id]
  #   }
  #   # "EDITOR" = {
  #   #   "user_ids" = ["2222222222-abcdefgh-1234-5678-abcd-999999999999"]
  #   # }
  # }


  # Workspace IAM role
  create_iam_role                = true
  iam_role_name                  = local.iam_role_name
  use_iam_role_name_prefix       = false
  iam_role_description           = local.description
  iam_role_path                  = "/grafana/"
  iam_role_force_detach_policies = true
  iam_role_max_session_duration  = 7200
  iam_role_tags                  = local.tags

  tags = local.tags
}
