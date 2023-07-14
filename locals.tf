locals {
  #name        = local.locals_vars.locals.name
  description = "Amazon Managed Grafana workspace for ${var.name}"

  tags = {
    GithubRepo = "terraform-aws-observability-accelerator"
    GithubOrg  = "aws-observability"
  }

  grafana_iam_role_name = module.managed_grafana.workspace_iam_role_name
  iam_role_name         = "aws-observability-workspace-iam-role"
  amg_ws_endpoint       = "https://${data.aws_grafana_workspace.this.endpoint}"
  amg_ws_id             = module.managed_grafana.workspace_id

  amp_ws_alias  = "observability-amp-workspace"
  amp_ws_region = var.aws_region

  grafana_workspace_id = data.aws_grafana_workspace.this.workspace_id
}
