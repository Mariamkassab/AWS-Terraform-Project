resource "aws_route_table" "rt" {
  vpc_id = var.created_vpc_id
  route {
    cidr_block = var.wanted_cidr 
    gateway_id = var.needed_gatway
  }
      
  tags = {
    Name = var.table_name
  }
}


resource "aws_route_table_association" "rt_a" {
  count = length(var.chosen_subnets)
  route_table_id = aws_route_table.rt.id
  subnet_id = var.chosen_subnets[count.index]
}