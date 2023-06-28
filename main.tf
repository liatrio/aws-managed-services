//TODO: Move the grafana module in the `modules/grafana` folder

locals {
  #name        = local.locals_vars.locals.name
  description = "Amazon Managed Grafana workspace for ${local.name}"


  tags = {
    GithubRepo = "terraform-aws-observability-accelerator"
    GithubOrg  = "aws-observability"
  }
  grafana_iam_role_name = module.managed_grafana.workspace_iam_role_name
}


# resource "aws_prometheus_workspace" "this" {
#   count = var.enable_managed_prometheus ? 1 : 0
#   alias = var.managed_prometheus_workspace_alias
#   tags  = var.tags
# }

# resource "aws_prometheus_alert_manager_definition" "this" {
#   count = var.enable_alertmanager ? 1 : 0

#   workspace_id = local.amp_ws_id

#   definition = <<EOF
# alertmanager_config: |
#     route:
#       receiver: 'default'
#     receivers:
#       - name: 'default'
# EOF
# }
# TODO: Tweak permissions to be least privileged.
provider "grafana" {
  url  = local.amg_ws_endpoint
  auth = module.managed_grafana.workspace_api_keys["admin"].key
}

module "managed_prometheus" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-managed-service-prometheus.git"
  
  create                = var.create
  create_workspace      = var.create_workspace

  workspace_alias       = var.managed_prometheus_workspace_alias

  rule_group_namespaces = var.rule_group_namespaces
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
  source = "terraform-aws-modules/managed-service-grafana/aws"
  #version = "1.8.0"

  name              = local.name
  associate_license = false
  description       = local.description
  //account_access_type       = "CURRENT_ACCOUNT"
  account_access_type       = var.account_access_type
  authentication_providers  = var.authentication_providers
  permission_type           = "SERVICE_MANAGED"
  data_sources              = var.data_sources
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

  # Workspace IAM role
  create_iam_role                = var.create_iam_role ? true : false
  iam_role_name                  = var.iam_role_name
  use_iam_role_name_prefix       = var.use_iam_role_name_prefix
  iam_role_description           = local.description
  iam_role_path                  = "/grafana/"
  iam_role_force_detach_policies = true
  iam_role_max_session_duration  = 7200
  iam_role_tags                  = local.tags

  tags = local.tags

  # SAML configuration settings
  create_saml_configuration = var.create_saml_configuration

  saml_admin_role_values  = var.create_saml_configuration ? var.saml_admin_role_values : []
  saml_editor_role_values = var.create_saml_configuration ? var.saml_editor_role_values : []
  saml_email_assertion    = var.create_saml_configuration ? var.saml_email_assertion : ""
  saml_groups_assertion   = var.create_saml_configuration ? var.saml_groups_assertion : ""
  saml_login_assertion    = var.create_saml_configuration ? var.saml_login_assertion : ""
  saml_name_assertion     = var.create_saml_configuration ? var.saml_name_assertion : ""
  saml_org_assertion      = var.create_saml_configuration ? var.saml_org_assertion : ""
  saml_role_assertion     = var.create_saml_configuration ? var.saml_role_assertion : ""
  saml_idp_metadata_url   = var.create_saml_configuration ? var.saml_idp_metadata_url : ""

  # vpc configuration
  vpc_configuration = {
    subnet_ids         = var.vpc_private_subnets
    security_group_ids = var.vpc_security_group_ids
  }

  nac_prefix_list_ids = var.nac_prefix_list_ids
  vpc_endpoint_ids    = var.vpc_endpoint_ids

  # Role associations
  # Ref: https://github.com/aws/aws-sdk/issues/25
  # Ref: https://github.com/hashicorp/terraform-provider-aws/issues/18812
  # WARNING: https://github.com/hashicorp/terraform-provider-aws/issues/24166
  # role_associations = {
  #   "ADMIN" = {
  #     "user_ids" = [data.aws_identitystore_user.user.user_id]
  #   }
  #   # "EDITOR" = {
  #   #   "user_ids" = ["2222222222-abcdefgh-1234-5678-abcd-999999999999"]
  #   # }
  # }

}
