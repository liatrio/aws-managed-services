# aws-managed-services
Contains AWS managed services.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.1.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.24.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | 1.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_managed_grafana"></a> [managed\_grafana](#module\_managed\_grafana) | github.com/liatrio/terraform-aws-managed-service-grafana.git | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/grafana_workspace) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | The account access type. | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_authentication_providers"></a> [authentication\_providers](#input\_authentication\_providers) | List containing the methods used to authenticate. | `list(any)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether a resources will be created | `bool` | `true` | no |
| <a name="input_create_dashboard_folder"></a> [create\_dashboard\_folder](#input\_create\_dashboard\_folder) | Boolean flag to enable Amazon Managed Grafana folder and dashboards | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Determines whether a an IAM role is created or to use an existing IAM role | `bool` | `true` | no |
| <a name="input_create_prometheus_data_source"></a> [create\_prometheus\_data\_source](#input\_create\_prometheus\_data\_source) | Boolean flag to enable Amazon Managed Grafana datasource | `bool` | `true` | no |
| <a name="input_create_saml_configuration"></a> [create\_saml\_configuration](#input\_create\_saml\_configuration) | Flag to indicate whether or not to create a SAML configuratino in Grafana Workspace. | `string` | `false` | no |
| <a name="input_create_workspace"></a> [create\_workspace](#input\_create\_workspace) | Determines whether a workspace will be created or to use an existing workspace | `bool` | `true` | no |
| <a name="input_data_sources"></a> [data\_sources](#input\_data\_sources) | List of data sources to create in the workspace | `list(string)` | <pre>[<br>  "CLOUDWATCH",<br>  "PROMETHEUS",<br>  "XRAY"<br>]</pre> | no |
| <a name="input_enable_alertmanager"></a> [enable\_alertmanager](#input\_enable\_alertmanager) | Creates Amazon Managed Service for Prometheus AlertManager for all workloads | `bool` | `false` | no |
| <a name="input_enable_managed_prometheus"></a> [enable\_managed\_prometheus](#input\_enable\_managed\_prometheus) | Creates a new Amazon Managed Service for Prometheus Workspace | `bool` | `true` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | Existing IAM role ARN for the workspace. Required if `create_iam_role` is set to `false` | `string` | `null` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of the IAM Role to create or associate with | `string` | `"aws-observability-workspace-iam-role"` | no |
| <a name="input_managed_grafana_workspace_id"></a> [managed\_grafana\_workspace\_id](#input\_managed\_grafana\_workspace\_id) | Amazon Managed Grafana Workspace ID | `string` | `""` | no |
| <a name="input_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#input\_managed\_prometheus\_workspace\_id) | Amazon Managed Service for Prometheus Workspace ID | `string` | `""` | no |
| <a name="input_managed_prometheus_workspace_region"></a> [managed\_prometheus\_workspace\_region](#input\_managed\_prometheus\_workspace\_region) | Region where Amazon Managed Service for Prometheus is deployed | `string` | `null` | no |
| <a name="input_nac_prefix_list_ids"></a> [nac\_prefix\_list\_ids](#input\_nac\_prefix\_list\_ids) | An array of prefix list IDs. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the deployment | `string` | `"aws-o11y-managed-services"` | no |
| <a name="input_saml_admin_role_values"></a> [saml\_admin\_role\_values](#input\_saml\_admin\_role\_values) | Name of the admin role value. | `list(any)` | n/a | yes |
| <a name="input_saml_editor_role_values"></a> [saml\_editor\_role\_values](#input\_saml\_editor\_role\_values) | Name of the editor role value. | `list(any)` | n/a | yes |
| <a name="input_saml_email_assertion"></a> [saml\_email\_assertion](#input\_saml\_email\_assertion) | Name of the saml email used for assertion. | `string` | n/a | yes |
| <a name="input_saml_groups_assertion"></a> [saml\_groups\_assertion](#input\_saml\_groups\_assertion) | Name of the saml groups used for assertion. | `string` | n/a | yes |
| <a name="input_saml_idp_metadata_url"></a> [saml\_idp\_metadata\_url](#input\_saml\_idp\_metadata\_url) | IDP Meta data url. | `string` | n/a | yes |
| <a name="input_saml_login_assertion"></a> [saml\_login\_assertion](#input\_saml\_login\_assertion) | Method of login used for assertion. | `string` | n/a | yes |
| <a name="input_saml_name_assertion"></a> [saml\_name\_assertion](#input\_saml\_name\_assertion) | Display name for SAML. | `string` | n/a | yes |
| <a name="input_saml_org_assertion"></a> [saml\_org\_assertion](#input\_saml\_org\_assertion) | Name of the org used for assertion. | `string` | n/a | yes |
| <a name="input_saml_role_assertion"></a> [saml\_role\_assertion](#input\_saml\_role\_assertion) | Name of the role used for assertion. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |
| <a name="input_use_iam_role_name_prefix"></a> [use\_iam\_role\_name\_prefix](#input\_use\_iam\_role\_name\_prefix) | Whether or not to use a prefix on the IAM Role name | `bool` | `true` | no |
| <a name="input_vpc_configuration"></a> [vpc\_configuration](#input\_vpc\_configuration) | The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to | `any` | `{}` | no |
| <a name="input_vpc_endpoint_ids"></a> [vpc\_endpoint\_ids](#input\_vpc\_endpoint\_ids) | An array of Amazon VPC endpoint IDs for the workspace. The only VPC endpoints that can be specified here are interface VPC endpoints for Grafana workspaces (using the com.amazonaws.[region].grafana-workspace service endpoint). Other VPC endpoints will be ignored. | `list(any)` | `[]` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | The list of Amazon EC2 subnet IDs created in the Amazon VPC for your Grafana workspace to connect. | `list(any)` | `[]` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | The list of Amazon EC2 security group IDs attached to the Amazon VPC for your Grafana workspace to connect. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS Region |
| <a name="output_create"></a> [create](#output\_create) | The creatae flag that gets passed to the module. |
| <a name="output_create_workspace"></a> [create\_workspace](#output\_create\_workspace) | The create\_workspace flag that gets passed to the module. |
| <a name="output_managed_grafana_workspace_endpoint"></a> [managed\_grafana\_workspace\_endpoint](#output\_managed\_grafana\_workspace\_endpoint) | Amazon Managed Grafana workspace endpoint |
| <a name="output_managed_grafana_workspace_id"></a> [managed\_grafana\_workspace\_id](#output\_managed\_grafana\_workspace\_id) | Amazon Managed Grafana workspace ID |
<!-- END_TF_DOCS -->