output "private_key" {
  value     = tls_private_key.tls_private_k.private_key_pem
  sensitive = true
}

output "public_ec2_1" {
  value = aws_instance.public_ec2_instance[0].id
}

output "public_ec2_2" {
  value = aws_instance.public_ec2_instance[1].id
}


output "private_ec2_1" {
  value = aws_instance.private_ec2_instance[0].id
}

output "private_ec2_2" {
  value = aws_instance.private_ec2_instance[1].id
}