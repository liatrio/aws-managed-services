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
  default = {
    GithubRepo = "terraform-aws-observability-accelerator"
    GithubOrg  = "aws-observability"
  }
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

variable "nac_configuration" {
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
  type        = list(any)
}

variable "saml_admin_role_values" {
  description = "Name of the admin role value."
  type        = list(any)
  default     = []
}

variable "saml_editor_role_values" {
  description = "Name of the editor role value."
  type        = list(any)
  default     = []
}

variable "saml_email_assertion" {
  description = "Name of the saml email used for assertion."
  type        = string
  default     = ""
}

variable "saml_groups_assertion" {
  description = "Name of the saml groups used for assertion."
  type        = string
  default     = ""
}
variable "saml_login_assertion" {
  description = "Method of login used for assertion."
  type        = string
  default     = ""
}
variable "saml_name_assertion" {
  description = "Display name for SAML."
  type        = string
  default     = ""
}
variable "saml_org_assertion" {
  description = "Name of the org used for assertion."
  type        = string
  default     = ""
}
variable "saml_role_assertion" {
  description = "Name of the role used for assertion."
  type        = string
  default     = ""
}
variable "saml_idp_metadata_url" {
  description = "IDP Meta data url."
  type        = string
  default     = ""
}

// TODO: fix these description to match the description from the module
variable "iam_role_name" {
  description = "The name of the IAM Role to create or associate with"
  type        = string
  default     = "aws-observability-workspace-iam-role"
}

variable "use_iam_role_name_prefix" {
  description = "Whether or not to use a prefix on the IAM Role name"
  type        = bool
  default     = true
}

variable "account_access_type" {
  description = "The account access type."
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "data_sources" {
  description = "List of data sources to create in the workspace"
  type        = list(string)
  default     = ["CLOUDWATCH", "PROMETHEUS", "XRAY"]
}

variable "name" {
  description = "The name of the deployment"
  type        = string
  default     = "aws-o11y-managed-services"
}

### AMP RELATED VARIABLES
variable "amp_create_workspace" {
  description = "Specifies if the AMP workspace has to be created or not"
  type        = bool
  default     = true
}

variable "amp_workspace_id" {
  description = "If 'amp_create_workspace' is set to 'false' then a workspace has to be supplied."
  type        = string
  default     = ""
}

variable "amp_ws_alias" {
  description = "The alias of the AMP workspace"
  type        = string
  default     = "observability-amp-workspace"
}

variable "idp_url_with_postfix" {
  description = "The FQDN of the IDP metadata URL with a postfix as needed to generate the metadata IDP url. Works for Ping"
  type        = string
  default     = ""
}

variable "generate_metadata_url" {
  description = "Boolean on whether or not to generate the metadata url"
  type        = bool
  default     = false
}

variable "alert_manager_config" {
  description = "The contents of the alarm rules file."
  type        = string
  default     = <<EOF
  alertmanager_config: |
      route:
        receiver: 'default'
      receivers:
        - name: 'default'
  EOF
}
variable "logging_configuration" {
  description = "Map that contains the logging configuration for prometheus."
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name"
  type        = string # "dev"
}

variable "route53_hosted_zone_name" {
  description = "value of the private hosted zone name"
  type        = string
  default     = "" # "csauto.observability.dev.aws.swacorp.com"
}

variable "aws_route53_zone_tags" {
  description = "value of the private hosted zone tags"
  type        = map(string)
  default     = {} # { "Name" = "observability.dev.aws.acme.com" }
}

variable "vpc_ids" {
  description = "List of VPC IDs"
  type        = list(string)
  default     = [] # ["vpc-0a1b2c3d4e5f6g7h", "vpc-7g6f5e4d3c2b1a0i"]
}

variable "amg_redirect_hostname" {
  description = "The hostname to which the S3 bucket will redirect requests"
  type        = string
  default     = "" # "g-c89c75e665.grafana-workspace.us-east-1.amazonaws.com"
}

variable "s3_website_endpoint_zone_ids" {
  description = "S3 website endpoint zone IDs by region"
  type        = map(string)
  default = {
    "us-east-1" = "Z3AQBSTGFYJSTF"
    "us-west-1" = "Z2F56UZL2M1ACD"
    "us-west-2" = "Z3BJ6K6RIION7M"
    # Add other regions as needed
  }
}

variable "create_amp_iam_role" {
  type        = bool
  default     = true
  description = "Whether to create the AMP IAM role or not. 1 per account is needed."
}

variable "create_redirect" {
  type        = bool
  default     = false
  description = "Whether to create a redirect from the S3 bucket to the workspace or not"
}

variable "aws_cloudwatch_log_group_retention_in_days" {
  description = "The retention period of the CloudWatch log group in days"
  type        = number
  default     = 60
}