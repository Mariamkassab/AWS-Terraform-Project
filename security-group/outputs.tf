output "sg_id" {
    value = aws_security_group.security_group.id
  
}

# output "private_sg_id" {
#     value = aws_security_group.security_group[1].id
  
# }