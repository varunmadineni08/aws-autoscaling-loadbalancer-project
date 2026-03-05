output "vpc_id" {
  value = aws_vpc.ag_vpc.id
}


output "subnet_ids" {
  value = [
    aws_subnet.ag_subnet_1.id,
    aws_subnet.ag_subnet_2.id
  ]
}

