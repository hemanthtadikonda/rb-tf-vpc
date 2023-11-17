data "aws_subnet" "default" {
  vpc_id = var.default_vpc_id
}