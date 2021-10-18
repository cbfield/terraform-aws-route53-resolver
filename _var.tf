variable "admitted_cidrs" {
  description = "CIDR blocks representing sources that are allowed to forward DNS requests through this resolver"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

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

variable "routes" {
  description = "Routes associated with the endpoints created for this resolver"
  type = list(object({
    cidr_block                 = string
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)
    carrier_gateway_id         = optional(string)
    egress_only_gateway_id     = optional(string)
    gateway_id                 = optional(string)
    instance_id                = optional(string)
    local_gateway_id           = optional(string)
    nat_gateway_id             = optional(string)
    network_interface_id       = optional(string)
    transit_gateway_id         = optional(string)
    vpc_endpoint_id            = optional(string)
    vpc_peering_connection_id  = optional(string)
  }))
  default = []
}

variable "transit_gateways" {
  description = "Transit gateways that you want to attach to the DNS VPC created by this module"
  type        = list(string)
  default     = []
}
