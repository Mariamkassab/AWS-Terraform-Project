output "vpc_id" {
     value = aws_vpc.terraform_vpc.id 
 }

output "internet_gateway_id" {
     value = aws_internet_gateway.internet_gateway.id
 }
