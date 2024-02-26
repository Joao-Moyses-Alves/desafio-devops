variable "cidr" {
  description = "CIDR block for the VPC"
}


variable "name" {
  description = "Name prefix for resources"
}


variable "enable_dns_support" {
  description = "Whether to enable DNS support for the VPC"
  default     = true
}


variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames for the VPC"
  default     = true
}


variable "create_internet_gateway" {
  description = "Whether to create an internet gateway"
  default     = true
}


variable "create_public_subnet" {
  description = "Whether to create a public subnet"
  default     = true
}


variable "create_private_subnets" {
  description = "Whether to create private subnets"
  default     = true
}


variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


variable "create_nat_gateway" {
  description = "Whether to create NAT gateways"
  default     = true
}


variable "create_route_tables" {
  description = "Whether to create route tables"
  default     = true
}


variable "create_subnets" {
  description = "Whether to create subnets"
  default     = true
}

