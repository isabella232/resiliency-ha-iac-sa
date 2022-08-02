## Requirements

No requirements.

## Providers

| Name                                                | Version |
| --------------------------------------------------- | ------- |
| <a name="provider_ibm"></a> [ibm](#provider_ibm)    | 1.42.0  |
| <a name="provider_null"></a> [null](#provider_null) | 3.1.0   |
| <a name="provider_time"></a> [time](#provider_time) | 0.7.2   |

## Modules

No modules.

## Resources

| Name                                                                                                                                              | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [ibm_is_floating_ip.bastion_floating_ip](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_floating_ip)              | resource    |
| [ibm_is_instance.bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance)                                | resource    |
| [ibm_is_security_group.bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group)                    | resource    |
| [ibm_is_security_group_rule.bastion_outbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource    |
| [ibm_is_security_group_rule.bastion_rule_22](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)  | resource    |
| [ibm_is_subnet.bastion_sub](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet)                                | resource    |
| [null_resource.delete_dynamic_ssh_key](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)                     | resource    |
| [null_resource.delete_dynamic_ssh_key_windows](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)             | resource    |
| [time_sleep.wait_240_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep)                                 | resource    |
| [ibm_iam_auth_token.auth_token](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_auth_token)                    | data source |

## Inputs

| Name                                                                                       | Description                                                                                                                                                                                                                           | Type        | Default | Required |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ------- | :------: |
| <a name="input_api_key"></a> [api_key](#input_api_key)                                     | Please enter the IBM Cloud API key.                                                                                                                                                                                                   | `string`    | n/a     |   yes    |
| <a name="input_bastion_image"></a> [bastion_image](#input_bastion_image)                   | Specify Image to be used with Bastion VSI                                                                                                                                                                                             | `string`    | n/a     |   yes    |
| <a name="input_bastion_ip_count"></a> [bastion_ip_count](#input_bastion_ip_count)          | IP count is the total number of total_ipv4_address_count for Bastion Subnet                                                                                                                                                           | `number`    | n/a     |   yes    |
| <a name="input_bastion_os_type"></a> [bastion_os_type](#input_bastion_os_type)             | OS image to be used [windows \| linux]                                                                                                                                                                                                | `string`    | n/a     |   yes    |
| <a name="input_bastion_profile"></a> [bastion_profile](#input_bastion_profile)             | Specify the profile needed for Bastion VSI                                                                                                                                                                                            | `string`    | n/a     |   yes    |
| <a name="input_bastion_ssh_key"></a> [bastion_ssh_key](#input_bastion_ssh_key)             | This is the name of the ssh key which will be generated dynamically on the bastion server and further will be attached with all the other Web/App/DB servers. It will be used to login to Web/App/DB servers via Bastion server only. | `string`    | n/a     |   yes    |
| <a name="input_my_public_ip"></a> [my_public_ip](#input_my_public_ip)                      | Provide the User's Public IP address in the format X.X.X.X which will be used to login to Bastion VSI. Also Please update your changed public IP address every time before executing terraform apply                                  | `string`    | n/a     |   yes    |
| <a name="input_prefix"></a> [prefix](#input_prefix)                                        | Prefix for all the resources.                                                                                                                                                                                                         | `string`    | n/a     |   yes    |
| <a name="input_region"></a> [region](#input_region)                                        | Please enter a region from the following available region and zones mapping: <br>us-south<br>us-east<br>eu-gb<br>eu-de<br>jp-tok<br>au-syd<br>jp-osa<br>br-sao<br>ca-tor                                                                                            | `string`    | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Resource Group Name is used to separate the resources in a group.                                                                                                                                                                     | `string`    | n/a     |   yes    |
| <a name="input_user_ssh_key"></a> [user_ssh_key](#input_user_ssh_key)                      | This is the existing ssh key on the User's machine and will be attached with the bastion server only. This will ensure the incoming connection on Bastion Server only from the users provided ssh_keys                                | `list(any)` | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                        | Required parameter vpc_id                                                                                                                                                                                                             | `string`    | n/a     |   yes    |
| <a name="input_zone"></a> [zone](#input_zone)                                              | Availability Zone where bastion resource will be created                                                                                                                                                                              | `string`    | n/a     |   yes    |

## Outputs

| Name                                                              | Description                        |
| ----------------------------------------------------------------- | ---------------------------------- |
| <a name="output_bastion_ip"></a> [bastion_ip](#output_bastion_ip) | Bastion Server Floating IP Address |
| <a name="output_bastion_sg"></a> [bastion_sg](#output_bastion_sg) | Security Group ID for the bastion  |
