resource "aws_vpc" "main" {
  cidr_block = var.cidr
}

module "subnets" {
  source = "./subnets"
  for_each = var.subnets
  vpc_id = aws_vpc.main.id
  subnets = each.value

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vpc-igw"
  }
}
#resource "aws_route" "r" {
#  route_table_id            = lookup(lookup(module.subnets, "public",null )
#  destination_cidr_block    = "0.0.0.0/0"
#  gateway_id                = aws_internet_gateway.igw.id
#}