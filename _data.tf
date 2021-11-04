data "aws_region" "current" {}

data "aws_route53_resolver_endpoint" "inbound" {
  resolver_endpoint_id = aws_route53_resolver_endpoint.inbound.id
}
