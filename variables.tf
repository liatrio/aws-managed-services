variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "enable_managed_prometheus" {
  description = "Creates a new Amazon Managed Service for Prometheus Workspace"
  type        = bool
  default     = true
}

variable "managed_prometheus_workspace_id" {
  description = "Amazon Managed Service for Prometheus Workspace ID"
  type        = string
  default     = ""
}

variable "managed_prometheus_workspace_region" {
  description = "Region where Amazon Managed Service for Prometheus is deployed"
  type        = string
  default     = null
}

variable "enable_alertmanager" {
  description = "Creates Amazon Managed Service for Prometheus AlertManager for all workloads"
  type        = bool
  default     = false
}

variable "managed_grafana_workspace_id" {
  description = "Amazon Managed Grafana Workspace ID"
  type        = string
  default     = ""
}

variable "grafana_api_key" {
  description = "Grafana API key for the Amazon Managed Grafana workspace"
  type        = string
  default = ""
}

variable "create_prometheus_data_source" {
  description = "Boolean flag to enable Amazon Managed Grafana datasource"
  type        = bool
  default     = true
}

variable "create_dashboard_folder" {
  description = "Boolean flag to enable Amazon Managed Grafana folder and dashboards"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}

variable "create" {
  description = "Determines whether a resources will be created"
  type        = bool
  default     = true
}

variable "create_workspace" {
  description = "Determines whether a workspace will be created or to use an existing workspace"
  type        = bool
  default     = true
}

variable "create_iam_role" {
  description = "Determines whether a an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "vpc_configuration" {
  description = "The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to"
  type        = any
  default     = {}
}

variable "iam_role_arn" {
  description = "Existing IAM role ARN for the workspace. Required if `create_iam_role` is set to `false`"
  type        = string
  default     = null
}

variable "create_saml_configuration" {
  description = "Flag to indicate whether or not to create a SAML configuratino in Grafana Workspace."
  type        = string
  default     = false
}

variable "authentication_providers" {
  description = "List containing the methods used to authenticate."
  type        = list
}

variable "saml_admin_role_values" {
  description = "Name of the admin role value."
  type        = list
}

variable "saml_editor_role_values" {
  description = "Name of the editor role value."
  type        = list
}

variable "saml_email_assertion" {
  description = "Name of the saml email used for assertion."
  type        = string
}

variable "saml_groups_assertion" {
  description = "Name of the saml groups used for assertion."
  type        = string
}
variable "saml_login_assertion" {
  description = "Method of login used for assertion."
  type        = string
}
variable "saml_name_assertion" {
  description = "Display name for SAML."
  type        = string
}
variable "saml_org_assertion" {
  description = "Name of the org used for assertion."
  type        = string
}
variable "saml_role_assertion" {
  description = "Name of the role used for assertion."
  type        = string
}
variable "saml_idp_metadata_url" {
  description = "IDP Meta data url."
  type        = string
}