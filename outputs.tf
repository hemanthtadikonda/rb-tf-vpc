output "subnets" {
  value = module.subnets
}
output "def_subnets" {
  value = data.aws_subnet.default
}