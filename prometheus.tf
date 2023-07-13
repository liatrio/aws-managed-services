# resource "grafana_folder" "this" {
#   title = "Amazon Managed Prometheus monitoring dashboards"
# }

resource "aws_prometheus_workspace" "amp_ws" {
  count = var.enable_managed_prometheus == true ? 1 : 0
  alias = local.amp_ws_alias
}

resource "aws_iam_role" "amp_iam_role" {
  name = "amp_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "aps:RemoteWrite", 
          "aps:GetSeries", 
          "aps:GetLabels",
          "aps:GetMetricMetadata"
      ], 
      "Resource": "*"
    }
  ]
}
EOF

  tags = {
    description = "IAM Role used by prometheus on EKS to interact with AMP"
  }
}

## TODO: Moved this where it makes sense, currently in this file/folder for ease of iterating
module "managed_prometheus" {
  count = var.enable_managed_prometheus == true ? 1 : 0
  source                           = "github.com/liatrio/terraform-aws-managed-service-prometheus.git" #this should be using the official, but for dev purposes using liatrio fork

  create_workspace = var.amp_create_workspace == true ? var.amp_create_workspace : false
  workspace_id = var.amp_workspace_id
}
