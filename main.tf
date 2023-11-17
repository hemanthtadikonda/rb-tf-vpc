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
resource "aws_route" "igw" {
  for_each = lookup(lookup(module.subnets, "public",null ),"route_table_ids",null)
  route_table_id            = each.value["id"]
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}
resource "aws_eip" "ngw" {
  count = length(local.public_subnets_id)
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count         = length(local.public_subnets_id)
  allocation_id = element(aws_eip.ngw.*.id, count.index )
  subnet_id     = element(local.public_subnets_id,count.index )

  tags = {
    Name = "gw NAT"
  }
}
#
#resource "aws_route" "r" {
#  count = length(local.private_route_table_id)
#  route_table_id            = local.private_route_table_id
#  destination_cidr_block    = "0.0.0.0/0"
#  nat_gateway_id            = element(aws_nat_gateway.ngw.*.id,count.index )
#}
#
#resource "aws_vpc_peering_connection" "peering" {
#  peer_vpc_id   = aws_vpc.main.id
#  vpc_id        = var.default_vpc_id
#  auto_accept   = true
#
#}
#resource "aws_route" "peer" {
#  count = length(local.private_route_table_id)
#  route_table_id            = local.private_route_table_id
#  destination_cidr_block    = var.default_vpc_cidr_block
#  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
#  depends_on                = [aws_route_table.testing]
#}
#
#resource "aws_route" "default-vpc-peer-entry" {
#  route_table_id            = data.aws_subnet.
#  destination_cidr_block    = "10.0.1.0/22"
#  vpc_peering_connection_id = "pcx-45ff3dc1"
#  depends_on                = [aws_route_table.testing]
#}




