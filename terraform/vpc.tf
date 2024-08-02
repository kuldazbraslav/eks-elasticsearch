data "aws_availability_zones" "region_zones" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  name = "${var.release_name}-vpc"
  # TODO: Put this into variable, together with private and public subnets
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.region_zones.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.default_tags
}
