# resource "grafana_folder" "this" {
#   title = "Amazon Managed Prometheus monitoring dashboards"
# }


## TODO: Moved this where it makes sense, currently in this file/folder for ease of iterating
module "managed_prometheus" {
  source                           = "github.com/liatrio/terraform-aws-managed-service-prometheus.git"
#   dashboards_folder_id             = resource.grafana_folder.this.id
  aws_region                       = local.amp_ws_region
  managed_prometheus_workspace_ids = var.managed_prometheus_workspace_ids
}
