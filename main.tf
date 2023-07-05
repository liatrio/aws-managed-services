//TODO: Move the grafana module in the `modules/grafana` folder

locals {
  #name        = local.locals_vars.locals.name
  description = "Amazon Managed Grafana workspace for ${var.name}"


  tags = {
    GithubRepo = "terraform-aws-observability-accelerator"
    GithubOrg  = "aws-observability"
  }
  grafana_iam_role_name = module.managed_grafana.workspace_iam_role_name
  iam_role_name         = "aws-observability-workspace-iam-role"
}

module "managed_grafana" {
  source = "terraform-aws-modules/managed-service-grafana/aws"
  #version = "1.8.0"

  name                      = var.name
  associate_license         = false
  description               = local.description
  account_access_type       = var.account_access_type
  authentication_providers  = var.authentication_providers
  permission_type           = "SERVICE_MANAGED"
  data_sources              = var.data_sources
  notification_destinations = ["SNS"]
  stack_set_name            = var.name
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

  nac_configuration = {
    nac_prefix_list_ids = var.nac_prefix_list_ids
    vpc_endpoint_ids    = var.vpc_endpoint_ids
  }
}
