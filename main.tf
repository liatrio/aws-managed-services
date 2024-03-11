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
}

resource "aws_iam_role_policy" "grafana_xray_policy" {
  depends_on = [module.managed_grafana]

  name = "GrafanaXrayDatasourcePolicy"
  role = module.managed_grafana.workspace_iam_role_arn

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowReadingMetricsFromCloudWatch",
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:DescribeAlarmHistory",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetInsightRuleReport"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowReadingLogsFromCloudWatch",
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogGroups",
          "logs:GetLogGroupFields",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:GetQueryResults",
          "logs:GetLogEvents"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowReadingTagsInstancesRegionsFromEC2",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowReadingResourcesForTags",
        "Effect" : "Allow",
        "Action" : "tag:GetResources",
        "Resource" : "*"
      },
      {
        "Action" : [
          "oam:ListSinks",
          "oam:ListAttachedLinks"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "xray:BatchGetTraces",
          "xray:GetTraceSummaries",
          "xray:GetTraceGraph",
          "xray:GetGroups",
          "xray:GetTimeSeriesServiceStatistics",
          "xray:GetInsightSummaries",
          "xray:GetInsight",
          "xray:GetServiceGraph",
          "ec2:DescribeRegions"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "aps:ListRules",
          "aps:ListAlertManagerSilences",
          "aps:ListAlertManagerAlerts",
          "aps:GetAlertManagerStatus",
          "aps:ListAlertManagerAlertGroups",
          "aps:PutAlertManagerSilences",
          "aps:DeleteAlertManagerSilence"
        ],
        "Resource" : "*"
      }
    ]
  })
}
