output "azs1" {
  value = data.aws_availability_zones.azs1.names
}

output "lenth-azs1" {
  value = length(data.aws_availability_zones.azs1.names)
}