# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  value = data.aws_subnet.eu-north-1a.id
}

output "sg_id" {
  value = aws_security_group.sg.id
}

output "subnets_ids" {
  value = aws_subnet.subnets.*.id
}

output "subnet_id_1a" {
  value = data.aws_subnet.eu-north-1a.id
}