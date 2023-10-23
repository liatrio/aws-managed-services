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
  value       = module.managed_prometheus[0].managed_prometheus_workspace
}

output "managed_grafana_workspace_endpoint" {
  description = "Amazon Managed Grafana workspace endpoint"
  value       = local.amg_ws_endpoint
}

output "managed_grafana_workspace_id" {
  description = "Amazon Managed Grafana workspace ID"
  value       = local.amg_ws_id
}

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