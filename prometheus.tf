# resource "grafana_folder" "this" {
#   title = "Amazon Managed Prometheus monitoring dashboards"
# }

resource "aws_prometheus_workspace" "amp_ws" {
  count = var.enable_managed_prometheus == true ? 1 : 0
  alias = local.amp_ws_alias
}

## TODO: Moved this where it makes sense, currently in this file/folder for ease of iterating
module "managed_prometheus" {
  count = var.enable_managed_prometheus == true ? 1 : 0
  source                           = "github.com/liatrio/terraform-aws-managed-service-prometheus.git"
  aws_region                       = local.amp_ws_region
  managed_prometheus_workspace_ids = list(resource.amp_ws.id)
}
