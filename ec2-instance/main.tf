resource "tls_private_key" "tls_private_k" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.tls_private_k.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}


resource "aws_instance" "public_ec2_instance" { 
  count = length(var.pub_instance_name)
  instance_type = var.instance_type   #"t2.micro"
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = var.pub_sub[count.index]
  vpc_security_group_ids   = var.pub_sg
  key_name      = aws_key_pair.generated_key.key_name
  #user_data     = file ( "./userdata2.tpl" )
  associate_public_ip_address = var.pub_associate_ip

  tags = {
    Name = var.pub_instance_name[count.index]
  }
  provisioner "remote-exec" {
     inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "sudo sed -i \"52 i proxy_pass http://${var.lb_dns};\" /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx"
    ]    


   connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.tls_private_k.private_key_pem                  
      host        = self.public_ip
      timeout = "4m"
    }
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ./all-ips.txt"
  }

}
resource "aws_instance" "private_ec2_instance" { 
  count = length(var.private_instance_name)
  instance_type = var.instance_type   #"t2.micro"
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = var.private_sub[count.index]
  vpc_security_group_ids   = var.pub_sg 
  key_name      = aws_key_pair.generated_key.key_name
  user_data     = file ( var.instance_us )
  associate_public_ip_address = var.private_associate_ip

  tags = {
    Name = var.private_instance_name[count.index]
  }

 provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ./all-ips.txt"
  }

}


resource "local_file" "private_key_file" {
  filename = "/home/mariam/Desktop/terr_task/lab 3/pk.pem"
  content  = tls_private_key.tls_private_k.private_key_pem
}