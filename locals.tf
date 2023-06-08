data "aws_region" "current" {
  name = "us-east-1"
}

data "aws_grafana_workspace" "this" {
  workspace_id = module.managed_grafana.workspace_id
}

locals {
  # if region is not passed, we assume the current one
  amp_ws_region   = coalesce(var.managed_prometheus_workspace_region, data.aws_region.current.name)
  amp_ws_id       = var.enable_managed_prometheus ? aws_prometheus_workspace.this[0].id : var.managed_prometheus_workspace_id
  amp_ws_endpoint = "https://aps-workspaces.${local.amp_ws_region}.amazonaws.com/workspaces/${local.amp_ws_id}/"

  amg_ws_endpoint = "https://${data.aws_grafana_workspace.this.endpoint}"
  amg_ws_id       = module.managed_grafana.workspace_id

  grafana_workspace_id = data.aws_grafana_workspace.this.workspace_id
  name = "aws-observability-accelerator-2"
}
