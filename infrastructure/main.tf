/*
module "ecr" {
  source = "./modules/ecr"
}


module "roles" {
  source = "./modules/roles"
}


module "network" {
  source = "./modules/network"

  cidr               = "10.0.0.0/16"                # Example CIDR block for the VPC
  name               = "desafio-devops"             # Example name prefix for resources
  availability_zones = ["us-east-1a", "us-east-1b"] # Example availability zones for subnets

  # Optionally, you can override other variables if needed
  # enable_dns_support       = true
  # enable_dns_hostnames     = true
  # create_internet_gateway  = true
  # create_public_subnet     = true
  # create_private_subnets   = true
  # create_nat_gateway       = true
  # create_route_tables      = true
  # create_subnets           = true
}


module "sg" {
  source     = "./modules/sg"
  depends_on = [module.network]
}

module "eks" {
  source     = "./modules/eks"
  depends_on = [module.sg]
}
*/
