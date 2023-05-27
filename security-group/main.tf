resource "aws_security_group" "security_group" {
  vpc_id = var.created_vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = var.egress_rules.port
    to_port     = var.egress_rules.port
    protocol    = var.egress_rules.protocol
    cidr_blocks = var.egress_rules.cidr_blocks
  }

  tags = {
    Name = var.sc_g_name
  }
}