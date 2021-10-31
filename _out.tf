output "admitted_cidrs" {
  description = "The value provided for var.admitted_cidrs"
  value       = var.admitted_cidrs
}

output "availability_zones" {
  description = "The value provided for var.availability_zones"
  value       = var.availability_zones
}

output "cidr_block" {
  description = "The value provided for var.cidr_block"
  value       = var.cidr_block
}

output "forwarded_domains" {
  description = "The provided value for var.forwarded_domains"
  value       = var.forwarded_domains
}

output "inbound_endpoints" {
  description = "Inbound endpoints used by the resolver"
  value       = aws_route53_resolver_endpoint.inbound
}

output "nacl" {
  description = "The network ACL that manages ingress and egress for the subnets containing the resolver endpoints"
  value       = aws_network_acl.nacl
}

output "name" {
  description = "The value provided for var.name"
  value       = var.name
}

output "outbound_endpoints" {
  description = "Outbound endpoints used by the resolver"
  value       = aws_route53_resolver_endpoint.outbound
}

output "region" {
  description = "The region containing this resolver"
  value       = data.aws_region.current
}

output "route_table" {
  description = "The route table used by the subnets containing the resolver endpoints"
  value       = aws_route_table.route_table
}

output "routes" {
  description = "The provided value for var.routes"
  value       = var.routes
}

output "rules" {
  description = "Resolver rules used by the resolver"
  value       = aws_route53_resolver_rule.rule
}

output "security_group" {
  description = "The security group associated with the resolver endpoints"
  value       = aws_security_group.endpoint_security_group
}

output "security_group_rules" {
  description = "Rules used by the security group associated with the resolver endpoints"
  value = {
    ingress = aws_security_group_rule.endpoint_ingress
    egress  = aws_security_group_rule.endpoint_egress
  }
}

output "subnets" {
  description = "The subnets containing the endpoints used by the resolver"
  value       = aws_subnet.subnet
}

output "transit_gateway_attachments" {
  description = "Attachments made from the VPC containing the resolver endpoints to transit gateways"
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment
}

output "transit_gateways" {
  description = "The provided valur for var.transit_gateways"
  value       = var.transit_gateways
}

output "vpc" {
  description = "The VPC that houses the endpoints for the resolver"
  value       = aws_vpc.vpc
}
