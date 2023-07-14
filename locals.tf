locals {
  #name        = local.locals_vars.locals.name
  description = "Amazon Managed Grafana workspace for ${var.name}"

  grafana_iam_role_name = module.managed_grafana.workspace_iam_role_name
  iam_role_name         = "aws-observability-workspace-iam-role"
  amg_ws_endpoint       = "https://${data.aws_grafana_workspace.this.endpoint}"
  amg_ws_id             = module.managed_grafana.workspace_id

  grafana_workspace_id = data.aws_grafana_workspace.this.workspace_id
}
