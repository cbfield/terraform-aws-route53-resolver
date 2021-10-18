# terraform-aws-route53-resolver
A Terraform module to create a Route 53 Resolver

# Terraform Docs

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment.tgw_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_network_acl.nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route53_resolver_endpoint.inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_endpoint.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route_table.route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.endpoint_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.endpoint_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.endpoint_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_route53_resolver_endpoint.inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admitted_cidrs"></a> [admitted\_cidrs](#input\_admitted\_cidrs) | CIDR blocks representing sources that are allowed to forward DNS requests through this resolver | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones in which to create subnets for the DNS VPC created for this resolver | `list(string)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block used by the DNS VPC created for this resolver | `string` | n/a | yes |
| <a name="input_forwarded_domains"></a> [forwarded\_domains](#input\_forwarded\_domains) | Domains for which rules will be created to route DNS queries through this resolver | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | A name to assign to the resources created for this resolver | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | Routes associated with the endpoints created for this resolver | <pre>list(object({<br>    cidr_block                 = string<br>    ipv6_cidr_block            = optional(string)<br>    destination_prefix_list_id = optional(string)<br>    carrier_gateway_id         = optional(string)<br>    egress_only_gateway_id     = optional(string)<br>    gateway_id                 = optional(string)<br>    instance_id                = optional(string)<br>    local_gateway_id           = optional(string)<br>    nat_gateway_id             = optional(string)<br>    network_interface_id       = optional(string)<br>    transit_gateway_id         = optional(string)<br>    vpc_endpoint_id            = optional(string)<br>    vpc_peering_connection_id  = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_transit_gateways"></a> [transit\_gateways](#input\_transit\_gateways) | Transit gateways that you want to attach to the DNS VPC created by this module | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admitted_cidrs"></a> [admitted\_cidrs](#output\_admitted\_cidrs) | The value provided for var.admitted\_cidrs |
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | The value provided for var.availability\_zones |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | The value provided for var.cidr\_block |
| <a name="output_forwarded_domains"></a> [forwarded\_domains](#output\_forwarded\_domains) | The provided value for var.forwarded\_domains |
| <a name="output_inbound_endpoints"></a> [inbound\_endpoints](#output\_inbound\_endpoints) | Inbound endpoints used by the resolver |
| <a name="output_nacl"></a> [nacl](#output\_nacl) | The network ACL that manages ingress and egress for the subnets containing the resolver endpoints |
| <a name="output_nacl_rules"></a> [nacl\_rules](#output\_nacl\_rules) | Rules used by the network ACL that manages ingress and agress for the subnets containing the resolver endpoints |
| <a name="output_name"></a> [name](#output\_name) | The value provided for var.name |
| <a name="output_outbound_endpoints"></a> [outbound\_endpoints](#output\_outbound\_endpoints) | Outbound endpoints used by the resolver |
| <a name="output_route_table"></a> [route\_table](#output\_route\_table) | The route table used by the subnets containing the resolver endpoints |
| <a name="output_routes"></a> [routes](#output\_routes) | The provided value for var.routes |
| <a name="output_rules"></a> [rules](#output\_rules) | Resolver rules used by the resolver |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | The security group associated with the resolver endpoints |
| <a name="output_security_group_rules"></a> [security\_group\_rules](#output\_security\_group\_rules) | Rules used by the security group associated with the resolver endpoints |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The subnets containing the endpoints used by the resolver |
| <a name="output_transit_gateway_attachments"></a> [transit\_gateway\_attachments](#output\_transit\_gateway\_attachments) | Attachments made from the VPC containing the resolver endpoints to transit gateways |
| <a name="output_transit_gateways"></a> [transit\_gateways](#output\_transit\_gateways) | The provided valur for var.transit\_gateways |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | The VPC that houses the endpoints for the resolver |
