#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "amp_log_group" {
  name_prefix       = "/o11y/amp/${var.environment}/"
  retention_in_days = var.aws_cloudwatch_log_group_retention_in_days
}

resource "aws_iam_role" "amp_iam_role" {
  count = var.create_amp_iam_role ? 1 : 0
  name  = "amp_iam_role_${var.environment}"

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
  name  = "amp_role_policy_${var.environment}"
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

# TODO: We are currently flowing data through the workspace above, we will eventually want to move everything to the workspace being created by this public module.
module "managed_prometheus" {
  count  = var.enable_managed_prometheus == true ? 1 : 0
  source = "terraform-aws-modules/managed-service-prometheus/aws"

  create_workspace         = var.amp_create_workspace == true ? var.amp_create_workspace : false
  workspace_id             = var.amp_workspace_id
  alert_manager_definition = var.alert_manager_config
  workspace_alias          = var.amp_ws_alias
  logging_configuration = {
    log_group_arn = "${aws_cloudwatch_log_group.amp_log_group.arn}:*"
  }
}
