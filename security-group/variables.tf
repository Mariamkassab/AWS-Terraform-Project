variable "created_vpc_id" {
  type = any
}

variable "ingress_rules" {
  type = map(object({
    port         = number
    protocol     = string
    cidr_blocks  = list(string)
  }))
}

variable "egress_rules" {
  type = object({
    port         = number
    protocol     = string
    cidr_blocks  = list(string)
  })
}

variable "sc_g_name" {
  type = string
}