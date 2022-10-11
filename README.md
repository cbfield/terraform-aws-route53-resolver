# terraform-aws-route53-resolver

This module creates a Route 53 DNS Resolver. This is intended to allow a VPC from one AWS account to resolve DNS from a private hosted zone in another AWS account.

This module creates a small VPC (referred to as a "DNS VPC" by most R53 docs), in which it creates inbound and outbound Route53 Resolver endpoints. The outbound endpoints are used to make rules to forward DNS queries to the inbound endpoints based on domain matching.

In order to use this to provision private DNS access to a VPC in another AWS account:
1. Create the resolver in the AWS account containing the private DNS records that you want to share (e.g. centralized networking account)
2. Associate the VPC created by this module with the private hosted zones you want it to provision access to, so these records can be resolved by the inbound endpoints in the VPC
3. Create forwarding rules for the domains of interest, using the `forwarded_domains` argument
4. Share those forwarding rules with the other AWS account containing your VPC
5. From the VPC's account, associate the VPC with the forwarding rules for each domain of interest

When a forwarding rule for a given outbound and inbound endpoint is used, the request originates from the outbound endpoint and its destination is the inbound endpoint. Thus, it is not required to peer this DNS VPC with any VPC that you want to provision with access to DNS. It is sufficient to associate that VPC with the forwarding rule for the desired domain(s).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>3.6 |

## Resources

| Name | Type |
|------|------|
| [aws_network_acl.nacl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
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
| [aws_vpc_dhcp_options.dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.dhcp_options_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_resolver_endpoint.inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_resolver_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones in which to create subnets for the DNS VPC created for this resolver | `list(string)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block used by the DNS VPC created for this resolver | `string` | n/a | yes |
| <a name="input_forwarded_domains"></a> [forwarded\_domains](#input\_forwarded\_domains) | Domains for which rules will be created to route DNS queries through this resolver | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | A name to assign to the resources created for this resolver | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | The value provided for var.availability\_zones |
| <a name="output_cidr_block"></a> [cidr\_block](#output\_cidr\_block) | The value provided for var.cidr\_block |
| <a name="output_forwarded_domains"></a> [forwarded\_domains](#output\_forwarded\_domains) | The provided value for var.forwarded\_domains |
| <a name="output_inbound_endpoints"></a> [inbound\_endpoints](#output\_inbound\_endpoints) | Inbound endpoints used by the resolver |
| <a name="output_nacl"></a> [nacl](#output\_nacl) | The network ACL that manages ingress and egress for the subnets containing the resolver endpoints |
| <a name="output_name"></a> [name](#output\_name) | The value provided for var.name |
| <a name="output_outbound_endpoints"></a> [outbound\_endpoints](#output\_outbound\_endpoints) | Outbound endpoints used by the resolver |
| <a name="output_region"></a> [region](#output\_region) | The region containing this resolver |
| <a name="output_route_table"></a> [route\_table](#output\_route\_table) | The route table used by the subnets containing the resolver endpoints |
| <a name="output_rules"></a> [rules](#output\_rules) | Resolver rules used by the resolver |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | The security group associated with the resolver endpoints |
| <a name="output_security_group_rules"></a> [security\_group\_rules](#output\_security\_group\_rules) | Rules used by the security group associated with the resolver endpoints |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The subnets containing the endpoints used by the resolver |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | The VPC that houses the endpoints for the resolver |
<!-- END_TF_DOCS -->