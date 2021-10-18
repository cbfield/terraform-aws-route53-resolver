resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "${var.name}-inbound"
  direction = "INBOUND"

  dynamic "ip_address" {
    for_each = toset(var.availability_zones)
    content {
      subnet_id = aws_subnet.subnet[ip_address.key].id
    }
  }

  security_group_ids = [aws_security_group.endpoint_security_group.id]

  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "${var.name}-outbound"
  direction = "OUTBOUND"

  dynamic "ip_address" {
    for_each = toset(var.availability_zones)
    content {
      subnet_id = aws_subnet.subnet[ip_address.key].id
    }
  }

  security_group_ids = [aws_security_group.endpoint_security_group.id]

  tags = {
    "Managed By Terraform" = "true"
  }
}

resource "aws_route53_resolver_rule" "rule" {
  for_each = toset(var.forwarded_domains)

  name                 = replace(each.key, ".", "-")
  domain_name          = each.key
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  dynamic "target_ip" {
    for_each = toset(data.aws_route53_resolver_endpoint.inbound.ip_addresses)
    content {
      ip = each.key
    }
  }
}
