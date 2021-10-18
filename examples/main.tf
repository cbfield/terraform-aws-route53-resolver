module "my_dns_resolver" {
  source = "../"

  name               = "my-dns-resolver"
  cidr_block         = "10.0.0.0/27"
  availability_zones = ["us-east-1a", "us-east-1b"]

  forwarded_domains = [
    "oof.owie.com",
    "oof.owie.net",
    "oof.owie.edu"
  ]

  admitted_cidrs = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]

  transit_gateways = ["tgw-123123"]
  routes = [
    {
      cidr_block         = "10.0.0.0/8"
      transit_gateway_id = "tgw-123123"
    },
    {
      cidr_block         = "172.16.0.0/12"
      transit_gateway_id = "tgw-123123"
    },
    {
      cidr_block         = "192.168.0.0/16"
      transit_gateway_id = "tgw-123123"
    },
  ]
}
