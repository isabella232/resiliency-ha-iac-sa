## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_ibm"></a> [ibm](#provider_ibm) | 1.42.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                        | Type        |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [ibm_is_instance_group.app_instance_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group)                                   | resource    |
| [ibm_is_instance_group.web_instance_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group)                                   | resource    |
| [ibm_is_instance_group_manager.app_instance_group_manager](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager)           | resource    |
| [ibm_is_instance_group_manager.web_instance_group_manager](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager)           | resource    |
| [ibm_is_instance_group_manager_policy.app_cpu_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy)         | resource    |
| [ibm_is_instance_group_manager_policy.app_memory_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy)      | resource    |
| [ibm_is_instance_group_manager_policy.app_network_in_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy)  | resource    |
| [ibm_is_instance_group_manager_policy.app_network_out_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy) | resource    |
| [ibm_is_instance_group_manager_policy.web_cpu_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy)         | resource    |
| [ibm_is_instance_group_manager_policy.web_memory_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy)      | resource    |
| [ibm_is_instance_group_manager_policy.web_network_in_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy)  | resource    |
| [ibm_is_instance_group_manager_policy.web_network_out_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_group_manager_policy) | resource    |
| [ibm_is_instance_template.app_template](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_template)                                   | resource    |
| [ibm_is_instance_template.web_template](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance_template)                                   | resource    |
| [ibm_is_instances.app_ig_members](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/is_instances)                                              | data source |
| [ibm_is_instances.web_ig_members](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/is_instances)                                              | data source |

## Inputs

| Name                                                                                                | Description                                                                                                                                         | Type                                                                                     | Default | Required |
| --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_app_aggregation_window"></a> [app_aggregation_window](#input_app_aggregation_window) | The aggregation window is the time period in seconds that the instance group manager monitors each instance and determines the average utilization. | `number`                                                                                 | n/a     |   yes    |
| <a name="input_app_config"></a> [app_config](#input_app_config)                                     | Application Configurations to be passed for App Instance Group creation                                                                             | `map(any)`                                                                               | n/a     |   yes    |
| <a name="input_app_cooldown_time"></a> [app_cooldown_time](#input_app_cooldown_time)                | Specify the cool down period, the number of seconds to pause further scaling actions after scaling has taken place.                                 | `number`                                                                                 | n/a     |   yes    |
| <a name="input_app_cpu_threshold"></a> [app_cpu_threshold](#input_app_cpu_threshold)                | Average target CPU Percent for CPU policy of App Instance Group                                                                                     | `number`                                                                                 | n/a     |   yes    |
| <a name="input_app_image"></a> [app_image](#input_app_image)                                        | Image ID for the App VSI for App Instance group template                                                                                            | `string`                                                                                 | n/a     |   yes    |
| <a name="input_app_max_servers_count"></a> [app_max_servers_count](#input_app_max_servers_count)    | Maximum App servers count for the App Instance group                                                                                                | `number`                                                                                 | n/a     |   yes    |
| <a name="input_app_min_servers_count"></a> [app_min_servers_count](#input_app_min_servers_count)    | Minimum App servers count for the App Instance group                                                                                                | `number`                                                                                 | n/a     |   yes    |
| <a name="input_app_placement_group_id"></a> [app_placement_group_id](#input_app_placement_group_id) | Placement group ID to be used for App servers.                                                                                                      | `string`                                                                                 | n/a     |   yes    |
| <a name="input_objects"></a> [objects](#input_objects)                                              | This variable will contains the objects of LB, LB Pool and LB Listeners.                                                                            | <pre>object({<br> lb = map(any)<br> pool = map(any)<br> listener = map(any)<br> })</pre> | n/a     |   yes    |
| <a name="input_prefix"></a> [prefix](#input_prefix)                                                 | This is the prefix text that will be prepended in every resource name created by this Module                                                        | `string`                                                                                 | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)          | Resource Group Name is used to separate the resources in a group.                                                                                   | `string`                                                                                 | n/a     |   yes    |
| <a name="input_sg_objects"></a> [sg_objects](#input_sg_objects)                                     | All Security Group objects. This is required parameter                                                                                              | `map(any)`                                                                               | n/a     |   yes    |
| <a name="input_ssh_key"></a> [ssh_key](#input_ssh_key)                                              | This is the ssh-key used to connect to the app/web/db VSI from Bastion VSI                                                                          | `list(any)`                                                                              | n/a     |   yes    |
| <a name="input_subnets"></a> [subnets](#input_subnets)                                              | All subnet objects. This is required parameter                                                                                                      | <pre>object({<br> app = any<br> web = any<br> })</pre>                                   | n/a     |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                 | Required parameter vpc_id                                                                                                                           | `string`                                                                                 | n/a     |   yes    |
| <a name="input_web_aggregation_window"></a> [web_aggregation_window](#input_web_aggregation_window) | The aggregation window is the time period in seconds that the instance group manager monitors each instance and determines the average utilization. | `number`                                                                                 | n/a     |   yes    |
| <a name="input_web_config"></a> [web_config](#input_web_config)                                     | Web Configurations to be passed for Web Instance Group creation                                                                                     | `map(any)`                                                                               | n/a     |   yes    |
| <a name="input_web_cooldown_time"></a> [web_cooldown_time](#input_web_cooldown_time)                | Specify the cool down period, the number of seconds to pause further scaling actions after scaling has taken place.                                 | `number`                                                                                 | n/a     |   yes    |
| <a name="input_web_cpu_threshold"></a> [web_cpu_threshold](#input_web_cpu_threshold)                | Average target CPU Percent for CPU policy of Web Instance Group                                                                                     | `number`                                                                                 | n/a     |   yes    |
| <a name="input_web_image"></a> [web_image](#input_web_image)                                        | Image ID for the Web VSI for Web Instance group template                                                                                            | `string`                                                                                 | n/a     |   yes    |
| <a name="input_web_max_servers_count"></a> [web_max_servers_count](#input_web_max_servers_count)    | Maximum Web servers count for the Web Instance group                                                                                                | `number`                                                                                 | n/a     |   yes    |
| <a name="input_web_min_servers_count"></a> [web_min_servers_count](#input_web_min_servers_count)    | Minimum Web servers count for the Web Instance group                                                                                                | `number`                                                                                 | n/a     |   yes    |
| <a name="input_web_placement_group_id"></a> [web_placement_group_id](#input_web_placement_group_id) | Placement group ID to be used for Web servers.                                                                                                      | `string`                                                                                 | n/a     |   yes    |
| <a name="input_zone"></a> [zone](#input_zone)                                                       | Resources will be created in the user specified zone                                                                                                | `string`                                                                                 | n/a     |   yes    |

## Outputs

| Name                                                                                | Description |
| ----------------------------------------------------------------------------------- | ----------- |
| <a name="output_app_instances_ip"></a> [app_instances_ip](#output_app_instances_ip) | Private IP addresses for the App VSI |
| <a name="output_web_instances_ip"></a> [web_instances_ip](#output_web_instances_ip) | Private IP addresses for the Web VSI |
