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

  dynamic "ingress" {
    for_each = toset(var.admitted_cidrs)

    content {
      action     = "allow"
      cidr_block = ingress.key
      from_port  = 53
      protocol   = "udp"
      rule_no    = 1 + index((sort(var.admitted_cidrs)), ingress.key)
      to_port    = 53
    }
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    protocol   = "udp"
    rule_no    = 1
    to_port    = 53
  }

  tags = {
    "Managed By Terraform" = "true"
    "Name"                 = "${var.name}"
  }
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
