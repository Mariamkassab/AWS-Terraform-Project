variable "lb_name" {
  type = list
}

variable "internal_or" {
  type = list(bool)
}

variable "lb_type" {
  type = list(string)
}

variable "lb_sg" {
  type = list
}

variable "pub_subnets" {
  type = list   ######
}

variable "private_subnets" {
  type = list
}

variable "lb_env" {
  type = list(string)
}

variable "tg_name" {
  type = list
}

variable "tg_port" {
  type = number
}

variable "tg_protocol" {
  type = string
}

variable "created_vpc_id" {
  type = any
}


variable "default_action_type" {
    type = string
}


