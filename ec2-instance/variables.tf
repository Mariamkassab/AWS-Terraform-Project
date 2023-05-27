variable "key_name" {
    type = any
}

variable "instance_type" {
  type = string
}

variable "pub_sg" {
  type = list
}

variable "private_sg" {
  type = list
}

variable "instance_us" {
  type = any
}

variable "pub_associate_ip" {
  type = bool
}

variable "private_associate_ip" {
  type = bool
}

variable "pub_instance_name" {
  type = list
}

variable "private_instance_name" {
  type = list
}

variable "pub_sub" {
  type = list
}

variable "private_sub" {
  type = list
}

variable "lb_dns" {
  type = any
}