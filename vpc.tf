resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  }
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

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}"
  }
}

resource "aws_network_acl_rule" "ingress" {
  for_each = toset(var.admitted_cidrs)

  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100 + index(var.admitted_cidrs, each.key)
  egress         = false
  from_port      = 53
  to_port        = 53
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = each.key
}

resource "aws_network_acl_rule" "egress" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100
  egress         = true
  from_port      = 53
  to_port        = 53
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route = var.routes

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
  description       = "DNS requests forwarded from other VPCs"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = var.admitted_cidrs
  security_group_id = aws_security_group.endpoint_security_group.id
}

resource "aws_security_group_rule" "endpoint_egress" {
  description       = "DNS requests to Route 53 service"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.endpoint_security_group.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  for_each = toset(var.transit_gateways)

  transit_gateway_id = each.key
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = [for subnet in aws_subnet.subnet : subnet.id]

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = var.name
  }
}
