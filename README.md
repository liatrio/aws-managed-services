# aws-managed-services
Contains AWS managed services.

## AMG Private VPC Connectivity

To set up AMG to work with a VPC you must provide the `vpc_private_subnets` and `vpc_security_group_ids` inputs. This will set up the outbound VPC connections.

If you want to restrict traffic to AMG we need to set up Network Access Controls. You **can** provide a prefix list via the `nac_prefix_list_ids` input and you **must** provide the vpc endpoint via the `vpc_endpoint_ids` input. 

If you do not provide the nac_configuration then AMG will be open to the internet and can be publicly accessed through the URL generated by the workspace.

When you set up NAC the VPC endpoint URL will not have a route to the public URL that the Grafana workspace provides, so you will need to establish that route yourself in some way. Below are some possible solutions you could implement: 

- Add the VPCE IP addresses and public url to your hosts file.

    **Example**: 
    
    <ip address> <workspace-id>.grafana-workspace.<region>.amazonaws.com
    ![](img/hosts_file.png)

    The IP address is the subnet associated with the VPCE. You can find it by navigating to the VPC dashboard, selecting **Endpoints** and opening your VPC endpoint.
    ![](img/vpc_subnet_ip.png)
    The URL is the Public URL provided by the Grafana workspace when created. You can find it by navigating to Amazon Managed Grafana, clicking on workspace, and selecting your grafana workspace.
    ![](img/grafana_public_url.png)

- Implement a reverse proxy inside the VPC that will redirect to the public url.

    **_NOTE:_** This is an assumption as we have not tested it.

- Have DNS infrastructure resolve to the VPCE DNS instead of the public.
[Route 53 Resolver endpoints and forwarding rule](https://docs.aws.amazon.com/whitepapers/latest/hybrid-cloud-dns-options-for-vpc/route-53-resolver-endpoints-and-forwarding-rules.html)

    **_NOTE:_** This is an assumption as we have not tested it.

## Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.7.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.24.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.7.0 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_managed_grafana"></a> [managed\_grafana](#module\_managed\_grafana) | github.com/liatrio/terraform-aws-managed-service-grafana.git | n/a |
| <a name="module_managed_prometheus"></a> [managed\_prometheus](#module\_managed\_prometheus) | terraform-aws-modules/managed-service-prometheus/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.amp_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.amp_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_prometheus_workspace.amp_ws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace) | resource |
| [aws_secretsmanager_secret.grafana_api_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.sa_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.sversion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [grafana_service_account.admin](https://registry.terraform.io/providers/grafana/grafana/2.2.0/docs/resources/service_account) | resource |
| [grafana_service_account_token.admin_service_account_token](https://registry.terraform.io/providers/grafana/grafana/2.2.0/docs/resources/service_account_token) | resource |
| [aws_grafana_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/grafana_workspace) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | The account access type. | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_amp_create_workspace"></a> [amp\_create\_workspace](#input\_amp\_create\_workspace) | Specifies if the AMP workspace has to be created or not | `bool` | `true` | no |
| <a name="input_amp_workspace_id"></a> [amp\_workspace\_id](#input\_amp\_workspace\_id) | If 'amp\_create\_workspace' is set to 'false' then a workspace has to be supplied. | `string` | `""` | no |
| <a name="input_amp_ws_alias"></a> [amp\_ws\_alias](#input\_amp\_ws\_alias) | The alias of the AMP workspace | `string` | `"observability-amp-workspace"` | no |
| <a name="input_asm_api_token_secret_name"></a> [asm\_api\_token\_secret\_name](#input\_asm\_api\_token\_secret\_name) | ASM secret name for the API token to be stored in | `string` | n/a | yes |
| <a name="input_asm_sa_token_secret_name"></a> [asm\_sa\_token\_secret\_name](#input\_asm\_sa\_token\_secret\_name) | ASM secret name for the service account token to be stored in | `string` | n/a | yes |
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
| <a name="input_generate_metadata_url"></a> [generate\_metadata\_url](#input\_generate\_metadata\_url) | Boolean on whether or not to generate the metadata url | `bool` | `false` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | Existing IAM role ARN for the workspace. Required if `create_iam_role` is set to `false` | `string` | `null` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The name of the IAM Role to create or associate with | `string` | `"aws-observability-workspace-iam-role"` | no |
| <a name="input_idp_url_with_postfix"></a> [idp\_url\_with\_postfix](#input\_idp\_url\_with\_postfix) | The FQDN of the IDP metadata URL with a postfix as needed to generate the metadata IDP url. Works for Ping | `string` | `""` | no |
| <a name="input_managed_grafana_workspace_id"></a> [managed\_grafana\_workspace\_id](#input\_managed\_grafana\_workspace\_id) | Amazon Managed Grafana Workspace ID | `string` | `""` | no |
| <a name="input_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#input\_managed\_prometheus\_workspace\_id) | Amazon Managed Service for Prometheus Workspace ID | `string` | `""` | no |
| <a name="input_managed_prometheus_workspace_region"></a> [managed\_prometheus\_workspace\_region](#input\_managed\_prometheus\_workspace\_region) | Region where Amazon Managed Service for Prometheus is deployed | `string` | `null` | no |
| <a name="input_nac_configuration"></a> [nac\_configuration](#input\_nac\_configuration) | The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the deployment | `string` | `"aws-o11y-managed-services"` | no |
| <a name="input_saml_admin_role_values"></a> [saml\_admin\_role\_values](#input\_saml\_admin\_role\_values) | Name of the admin role value. | `list(any)` | `[]` | no |
| <a name="input_saml_editor_role_values"></a> [saml\_editor\_role\_values](#input\_saml\_editor\_role\_values) | Name of the editor role value. | `list(any)` | `[]` | no |
| <a name="input_saml_email_assertion"></a> [saml\_email\_assertion](#input\_saml\_email\_assertion) | Name of the saml email used for assertion. | `string` | `""` | no |
| <a name="input_saml_groups_assertion"></a> [saml\_groups\_assertion](#input\_saml\_groups\_assertion) | Name of the saml groups used for assertion. | `string` | `""` | no |
| <a name="input_saml_idp_metadata_url"></a> [saml\_idp\_metadata\_url](#input\_saml\_idp\_metadata\_url) | IDP Meta data url. | `string` | `""` | no |
| <a name="input_saml_login_assertion"></a> [saml\_login\_assertion](#input\_saml\_login\_assertion) | Method of login used for assertion. | `string` | `""` | no |
| <a name="input_saml_name_assertion"></a> [saml\_name\_assertion](#input\_saml\_name\_assertion) | Display name for SAML. | `string` | `""` | no |
| <a name="input_saml_org_assertion"></a> [saml\_org\_assertion](#input\_saml\_org\_assertion) | Name of the org used for assertion. | `string` | `""` | no |
| <a name="input_saml_role_assertion"></a> [saml\_role\_assertion](#input\_saml\_role\_assertion) | Name of the role used for assertion. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | `map(string)` | <pre>{<br>  "GithubOrg": "aws-observability",<br>  "GithubRepo": "terraform-aws-observability-accelerator"<br>}</pre> | no |
| <a name="input_use_iam_role_name_prefix"></a> [use\_iam\_role\_name\_prefix](#input\_use\_iam\_role\_name\_prefix) | Whether or not to use a prefix on the IAM Role name | `bool` | `true` | no |
| <a name="input_vpc_configuration"></a> [vpc\_configuration](#input\_vpc\_configuration) | The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS Region |
| <a name="output_create"></a> [create](#output\_create) | The creatae flag that gets passed to the module. |
| <a name="output_create_workspace"></a> [create\_workspace](#output\_create\_workspace) | The create\_workspace flag that gets passed to the module. |
| <a name="output_managed_grafana_workspace_endpoint"></a> [managed\_grafana\_workspace\_endpoint](#output\_managed\_grafana\_workspace\_endpoint) | Amazon Managed Grafana workspace endpoint |
| <a name="output_managed_grafana_workspace_id"></a> [managed\_grafana\_workspace\_id](#output\_managed\_grafana\_workspace\_id) | Amazon Managed Grafana workspace ID |
<!-- END_TF_DOCS -->

