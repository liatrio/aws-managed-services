//TODO: Move the grafana module in the `modules/grafana` folder
module "managed_grafana" {
  # This is a fork of the upstream community edition and will be set back to the published
  # module version once the fix for adding `nac_configuration` is merged upstream.
  source = "github.com/liatrio/terraform-aws-managed-service-grafana.git"
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
  iam_role_tags                  = var.tags

  tags = var.tags

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
  saml_idp_metadata_url   = var.create_saml_configuration && var.generate_metadata_url ? local.idp_metadata_url : var.saml_idp_metadata_url

  # vpc & nac configuration
  vpc_configuration = var.vpc_configuration
  nac_configuration = var.nac_configuration

  logging_configuration = var.logging_configuration
}
resource "aws_secretsmanager_secret" "grafana_api_token" {
  name       = var.asm_api_token_secret_name
  kms_key_id = aws_kms_key.secrets.arn
}

resource "aws_secretsmanager_secret" "grafana_sa_token" {
  name       = var.asm_sa_token_secret_name
  kms_key_id = aws_kms_key.secrets.arn
}

resource "aws_kms_key" "secrets" {
  enable_key_rotation = true
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.grafana_api_token.id
  secret_string = module.managed_grafana.workspace_api_keys["admin"].key
}

resource "aws_secretsmanager_secret_version" "sa_version" {
  secret_id     = aws_secretsmanager_secret.grafana_sa_token.id
  secret_string = grafana_service_account_token.admin_service_account_token.key

  depends_on = [
    grafana_service_account_token.admin_service_account_token
  ]
}

resource "grafana_service_account" "admin" {
  name        = "grafana_service_account_admin"
  role        = "Admin"
  is_disabled = false
}

resource "grafana_service_account_token" "admin_service_account_token" {
  name               = "service_account_admin_key"
  service_account_id = grafana_service_account.admin.id
  seconds_to_live    = 2592000
}

provider "grafana" {
  url  = local.amg_ws_endpoint
  auth = module.managed_grafana.workspace_api_keys["admin"].key
}
