module "vpc" {
  source            = "./modules/vpc"
  cidr_block        = "10.0.0.0/16"
  az_1              = "eu-north-1a"
  az_2              = "eu-north-1b"
  pub_subnet_1_cidr = "10.0.1.0/24"
  pub_subnet_2_cidr = "10.0.2.0/24"



}

module "autoscale" {
  source     = "./modules/autoscale"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
}