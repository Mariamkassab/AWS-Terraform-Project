
module "terraform_vpc" {
  source   = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "terraform vpc"
  gw_name  = "terraform internet gateway"
}

module "terraform_subnet" {
  source         = "./subnet"
  created_vpc_id = module.terraform_vpc.vpc_id
  subnet_cidr    = ["10.0.0.0/24", "10.0.2.0/24", "10.0.1.0/24", "10.0.3.0/24"]
  az             = ["eu-west-1a", "eu-west-1b", "eu-west-1a", "eu-west-1b"]
  subnet_name    = ["pub_sub1_az1", "pub_sub2_az2", "private_sub1_az1", "private_sub2_az2"]
}


module "public_security_group" {
  source         = "./security-group"
  created_vpc_id = module.terraform_vpc.vpc_id

  ingress_rules = {
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    http = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress_rules = {
    port        = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  sc_g_name = "public_security_group"
}


module "private_security_group" {
  source         = "./security-group"
  created_vpc_id = module.terraform_vpc.vpc_id

  ingress_rules = {
    ssh = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress_rules = {
    port        = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  sc_g_name = "private_security_group"
}

module "nat_gateway" {
  source           = "./nat"
  eip              = true
  public_subnet_id = module.terraform_subnet.first_pub_id
  nat_name         = "nat_gateway"
}

module "public_routing_table" {
  source         = "./route_table"
  created_vpc_id = module.terraform_vpc.vpc_id
  wanted_cidr    = "0.0.0.0/0"
  needed_gatway  = module.terraform_vpc.internet_gateway_id
  table_name     = "public_rt"
  chosen_subnets  = [module.terraform_subnet.first_pub_id, module.terraform_subnet.second_pub_id]
   } 


module "private_routing_table" {
  source         = "./route_table"
  created_vpc_id = module.terraform_vpc.vpc_id
  wanted_cidr    = "0.0.0.0/0"
  needed_gatway  = module.nat_gateway.nat_id
  table_name     = "private_rt"
  chosen_subnets  = [module.terraform_subnet.first_private_id, module.terraform_subnet.second_private_id]
   } 

module "lbs_creation" {
  source = "./alb"
  lb_name = ["public-lb" , "private-lb"]
  internal_or = [false , true]
  lb_type = ["application" , "application"]
  lb_sg = [module.public_security_group.sg_id , module.public_security_group.sg_id ]
  pub_subnets = [module.terraform_subnet.first_pub_id , module.terraform_subnet.second_pub_id] 
  private_subnets = [module.terraform_subnet.first_private_id , module.terraform_subnet.second_private_id]
  lb_env = ["dev_pub_lb" , "dev_private_lb"]
  tg_name = ["public-tg" , "privat-tg"]
  tg_port = 80
  tg_protocol = "HTTP"
  created_vpc_id = module.terraform_vpc.vpc_id
  default_action_type = "forward" 
}

module "ec2_creation" {
  source = "./ec2-instance"
  key_name = "ec2_key"
  instance_type = "t2.micro"
  pub_sub = [module.terraform_subnet.first_pub_id , module.terraform_subnet.second_pub_id]
  private_sub = [ module.terraform_subnet.first_private_id , module.terraform_subnet.second_private_id]
  pub_sg = [module.public_security_group.sg_id]
  private_sg = [module.private_security_group.sg_id]
  #instance_us = "userdata.tpl"
  pub_associate_ip = true
  private_associate_ip = false
  pub_instance_name = ["pub-1" , "pub-2"]
  private_instance_name = ["private-1" , "priavte-2"]
  lb_dns = module.lbs_creation.pri_lb_dns
  instance_us = "./userdata.tpl"
}

module "public_tg_attachment" {
  source = "./lb-tg-attach"
  tg_port = 80
  instances = [module.ec2_creation.public_ec2_1 , module.ec2_creation.public_ec2_2]
  lb_tg_arn = module.lbs_creation.lb_target_group_arn_pub
}

module "priavte_tg_attachment" {
  source = "./lb-tg-attach"
  tg_port = 80
  instances = [module.ec2_creation.private_ec2_1 , module.ec2_creation.private_ec2_2]
  lb_tg_arn = module.lbs_creation.lb_target_group_arn_pri
}