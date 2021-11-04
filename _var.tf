variable "availability_zones" {
  description = "Availability zones in which to create subnets for the DNS VPC created for this resolver"
  type        = list(string)
}

variable "cidr_block" {
  description = "The CIDR block used by the DNS VPC created for this resolver"
  type        = string
}

variable "forwarded_domains" {
  description = "Domains for which rules will be created to route DNS queries through this resolver"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "A name to assign to the resources created for this resolver"
  type        = string
}
