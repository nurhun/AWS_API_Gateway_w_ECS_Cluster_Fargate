# --- networking/variables.tf ---

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.0.0/24"
}

variable "subnet_availability_zone" {}

variable "security_group_name" {}

variable "security_group_description" {}