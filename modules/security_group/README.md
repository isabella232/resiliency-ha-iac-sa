## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_ibm"></a> [ibm](#provider_ibm) | 1.42.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                  | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [ibm_is_security_group.app](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group)                            | resource |
| [ibm_is_security_group.db](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group)                             | resource |
| [ibm_is_security_group.lb_sg](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group)                          | resource |
| [ibm_is_security_group.web](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group)                            | resource |
| [ibm_is_security_group_rule.app_outbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)         | resource |
| [ibm_is_security_group_rule.app_rule_22](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)          | resource |
| [ibm_is_security_group_rule.app_rule_80](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)          | resource |
| [ibm_is_security_group_rule.app_rule_lb_listener](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource |
| [ibm_is_security_group_rule.db_outbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)          | resource |
| [ibm_is_security_group_rule.db_rule_22](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)           | resource |
| [ibm_is_security_group_rule.db_rule_80](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)           | resource |
| [ibm_is_security_group_rule.db_rule_app_3306](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)     | resource |
| [ibm_is_security_group_rule.db_rule_web_3306](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)     | resource |
| [ibm_is_security_group_rule.lb_inbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)           | resource |
| [ibm_is_security_group_rule.lb_outbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)          | resource |
| [ibm_is_security_group_rule.web_outbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)         | resource |
| [ibm_is_security_group_rule.web_rule_22](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)          | resource |
| [ibm_is_security_group_rule.web_rule_443](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)         | resource |
| [ibm_is_security_group_rule.web_rule_80](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule)          | resource |

## Inputs

| Name                                                                                       | Description                                                                                                                                                                                          | Type     | Default | Required |
| ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_alb_port"></a> [alb_port](#input_alb_port)                                  | This is the Application load balancer listener port                                                                                                                                                  | `number` | n/a     |   yes    |
| <a name="input_bastion_sg"></a> [bastion_sg](#input_bastion_sg)                            | Bastion Security Group ID                                                                                                                                                                            | `string` | n/a     |   yes    |
| <a name="input_my_public_ip"></a> [my_public_ip](#input_my_public_ip)                      | Provide the User's Public IP address in the format X.X.X.X which will be used to login to Bastion VSI. Also Please update your changed public IP address every time before executing terraform apply | `string` | n/a     |   yes    |
| <a name="input_prefix"></a> [prefix](#input_prefix)                                        | Prefix for all the resources.                                                                                                                                                                        | `string` | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Resource Group Name is used to separate the resources in a group.                                                                                                                                    | `string` | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                        | Required parameter vpc_id                                                                                                                                                                            | `string` | n/a     |   yes    |

## Outputs

| Name                                                              | Description                                                         |
| ----------------------------------------------------------------- | ------------------------------------------------------------------- |
| <a name="output_app_sg"></a> [app_sg](#output_app_sg)             | Security Group ID for the app                                       |
| <a name="output_db_sg"></a> [db_sg](#output_db_sg)                | Security Group ID for the db                                        |
| <a name="output_lb_sg"></a> [lb_sg](#output_lb_sg)                | Security Group ID for Load Balancer                                 |
| <a name="output_sg_objects"></a> [sg_objects](#output_sg_objects) | This output variable will expose the objects of all security groups |
| <a name="output_web_sg"></a> [web_sg](#output_web_sg)             | Security Group ID for the web                                       |
