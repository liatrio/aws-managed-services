resource "aws_prometheus_workspace" "amp_ws" {
  count = var.enable_managed_prometheus == true ? 1 : 0
  alias = var.amp_ws_alias
}

resource "aws_iam_role" "amp_iam_role" {
  name = "amp_iam_role"

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

resource "aws_iam_role_policy" "amp_role_policy" {
  name = "amp_role_policy"
  role = aws_iam_role.amp_iam_role.id
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
}
