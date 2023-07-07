data "aws_region" "current" {
  name = var.aws_region
}

data "aws_grafana_workspace" "this" {
  workspace_id = module.managed_grafana.workspace_id
}
