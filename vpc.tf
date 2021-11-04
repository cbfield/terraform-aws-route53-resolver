resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  }
}

resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name = data.aws_region.current.name == "us-east-1" ? (
    "ec2.internal"
  ) : "${data.aws_region.current.name}.compute.amazonaws.com"

  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  }
}

resource "aws_vpc_dhcp_options_association" "dhcp_options_association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp_options.id
}

resource "aws_subnet" "subnet" {
  for_each = toset(var.availability_zones)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, ceil(length(var.availability_zones) / 2), index(var.availability_zones, each.key))

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}-${each.key}"
  }
}

resource "aws_network_acl" "nacl" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [for subnet in aws_subnet.subnet : subnet.id]

  ingress {
    cidr_block = var.cidr_block
    from_port  = 53
    to_port    = 53
    protocol   = "udp"
    action     = "allow"
    rule_no    = 1
  }

  egress {
    cidr_block = var.cidr_block
    from_port  = 53
    to_port    = 53
    protocol   = "udp"
    action     = "allow"
    rule_no    = 1
  }

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  }
}

resource "aws_route_table_association" "route_table_association" {
  for_each = toset(var.availability_zones)

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "endpoint_security_group" {
  name        = var.name
  description = "Manages access to ${var.name} resolver endpoints"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  }
}

resource "aws_security_group_rule" "endpoint_ingress" {
  description       = "DNS traffic forwarded from outbound to inbound endpoints"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.endpoint_security_group.id
}

resource "aws_security_group_rule" "endpoint_egress" {
  description       = "DNS traffic forwarded from outbound to inbound endpoints"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.endpoint_security_group.id
}
