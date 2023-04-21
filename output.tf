output "igw_id" {
  value = aws_internet_gateway.prod-igw.id 
}

output "vpc_id"{
    value = aws_vpc.main.id
}

output "public_subnet1_id" {
    value = aws_subnet.public_subnet_1.id
}

output "private_subnet_id" {
    value = aws_subnet.private_subnet_2.id
}  

output "nat-gateway_id" {
  value = aws_nat_gateway.nat-gateway.id
}

output "aws_instance_id" {
    value = aws_instance.new.id
}    
