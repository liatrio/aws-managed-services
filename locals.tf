locals {
  #name        = local.locals_vars.locals.name
  description = "Amazon Managed Grafana workspace for ${var.name}"

  grafana_iam_role_name = module.managed_grafana.workspace_iam_role_name
  iam_role_name         = "aws-observability-workspace-iam-role"

  amp_ws_endpoint  = module.managed_prometheus[0].workspace_prometheus_endpoint
  amg_ws_endpoint  = "https://${data.aws_grafana_workspace.this.endpoint}"
  amg_ws_id        = module.managed_grafana.workspace_id
  idp_metadata_url = var.generate_metadata_url ? "${var.idp_url_with_postfix}${data.aws_grafana_workspace.this.endpoint}/saml/metadata" : ""

  grafana_workspace_id = data.aws_grafana_workspace.this.workspace_id
}
