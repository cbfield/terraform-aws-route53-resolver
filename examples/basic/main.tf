module "my_dns_resolver" {
  source = "../../"

  name               = "my-dns-resolver"
  cidr_block         = "10.0.0.0/27"
  availability_zones = ["us-east-1a", "us-east-1b"]

  forwarded_domains = [
    "oof.owie.com",
    "oof.owie.net",
    "oof.owie.edu"
  ]
}
