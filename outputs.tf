output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "managed_prometheus_workspace_endpoint" {
  description = "Amazon Managed Prometheus workspace endpoint"
  value       = local.amp_ws_endpoint
}

output "managed_prometheus_workspace_id" {
  description = "Amazon Managed Prometheus workspace ID"
  value       = aws_prometheus_workspace.amp_ws[0].id
}

# output "managed_prometheus_workspace_region" {
#   description = "Amazon Managed Prometheus workspace region"
#   value       = local.amp_ws_region
# }

output "managed_grafana_workspace_endpoint" {
  description = "Amazon Managed Grafana workspace endpoint"
  value       = local.amg_ws_endpoint
}

output "managed_grafana_workspace_id" {
  description = "Amazon Managed Grafana workspace ID"
  value       = local.amg_ws_id
}

# output "grafana_dashboards_folder_id" {
#   description = "Grafana folder ID for automatic dashboards. Required by workload modules"
#   value       = var.create_dashboard_folder ? grafana_folder.this[0].id : ""
# }

# output "grafana_prometheus_datasource_test" {
#   description = "Grafana save & test URL for Amazon Managed Prometheus workspace"
#   value       = var.create_prometheus_data_source ? "${local.amg_ws_endpoint}/datasources/edit/${grafana_data_source.amp[0].uid}" : ""
# }

# output "grafana_dashboard_folder_created" {
#   description = "Boolean value indicating if the module created a dashboard folder in Amazon Managed Grafana"
#   value       = var.create_dashboard_folder
# }

# output "prometheus_data_source_created" {
#   description = "Boolean value indicating if the module created a prometheus data source in Amazon Managed Grafana"
#   value       = var.create_prometheus_data_source
# }

output "create" {
  description = "The creatae flag that gets passed to the module."
  value       = var.create
}

output "create_workspace" {
  description = "The create_workspace flag that gets passed to the module."
  value       = var.create_workspace
}

output "amg_route53_alias" {
  description = "value for the route53 alias, which contains the bucket name, hosted zone id and amg fqdn"
  value       = var.create_redirect ? aws_route53_record.s3_alias[0].name : ""
}

output "asm_amg_api_token_name" {
  description = "The name of the ASM vault that is storing the AMG API Token."
  value = aws_secretsmanager_secret.grafana_api_token.name
}
output "asm_amg_sa_token_name" {
  description = "The name of the ASM vault that is storing the AMG SA Token."
  value = aws_secretsmanager_secret.grafana_sa_token.name
}