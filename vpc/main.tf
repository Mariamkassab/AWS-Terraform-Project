resource "aws_vpc" "terraform_vpc" {
  cidr_block  = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = var.gw_name
  }
}