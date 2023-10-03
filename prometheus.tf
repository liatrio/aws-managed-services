resource "aws_cloudwatch_log_group" "amp_log_group" {
  name = "o11y-amp-default"
}

# TODO: We are currently flowing data through this workspace here, we will eventually want to move everything to the workspace being created by the public module.
resource "aws_prometheus_workspace" "amp_ws" {
  count = var.enable_managed_prometheus == true ? 1 : 0
  alias = var.amp_ws_alias

  # NOTE:
  # Currently commented this out in favour of a default log group (defined above).
  # Avoids having to manually define log groups prior to executingthe terraform module.
  #
  # ---
  # dynamic "logging_configuration" {
  #   for_each = length(var.logging_configuration) > 0 ? [var.logging_configuration] : []

  #   content {
  #     log_group_arn = logging_configuration.value.log_group_arn
  #   }
  # }

  logging_configuration {
    log_group_arn = aws_cloudwatch_log_group.amp_log_group.arn
  }
}

resource "aws_prometheus_alert_manager_definition" "this" {
  count = var.enable_alertmanager ? 1 : 0

  workspace_id = aws_prometheus_workspace.amp_ws[0].id

  definition = var.alert_manager_config
}

resource "aws_iam_role" "amp_iam_role" {
  count = var.create_amp_iam_role ? 1 : 0
  name  = "amp_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::AWS_ACCOUNT_ID:oidc-provider/OIDC_PROVIDER"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "OIDC_PROVIDER:sub": "system:serviceaccount:SERVICE_ACCOUNT_NAMESPACE:SERVICE_ACCOUNT_AMP_INGEST_NAME"
        }
      }
    }
  ]
}
EOF
}

# This policy follows Amazon's documentation for permissions required to get Prometheus working
# https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-ingest-metrics-new-Prometheus.html
# https://docs.aws.amazon.com/prometheus/latest/userguide/set-up-irsa.html#set-up-irsa-ingest
#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "amp_role_policy" {
  count = var.create_amp_iam_role ? 1 : 0
  name  = "amp_role_policy"
  role  = aws_iam_role.amp_iam_role[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "aps:RemoteWrite",
        "aps:GetSeries",
        "aps:GetLabels",
        "aps:GetMetricMetadata"
      ]
      Resource = "*"
    }]
  })
}

module "managed_prometheus" {
  count  = var.enable_managed_prometheus == true ? 1 : 0
  source = "terraform-aws-modules/managed-service-prometheus/aws"

  create_workspace = var.amp_create_workspace == true ? var.amp_create_workspace : false
  workspace_id     = var.amp_workspace_id

  logging_configuration = var.logging_configuration
}
