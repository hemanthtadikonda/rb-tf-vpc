locals {
  # Subnets
  public_subnets_id = [for k,v in lookup(lookup(module.subnets,"public",null ),"subnets_ids",null) : v.id ]
  app_subnets_id = [for k,v in lookup(lookup(module.subnets,"app",null ),"subnets_ids",null) : v.id ]
  db_subnets_id = [for k,v in lookup(lookup(module.subnets,"db",null ),"subnets_ids",null) : v.id ]
  private_subnet_id = concat(local.app_subnets_id , local.db_subnets_id)

  # RT
  public_route_table_ids = [for k,v in lookup(lookup(module.subnets,"public",null ),"route_table_ids",null) : v.id ]
  app_route_table_ids = [for k,v in lookup(lookup(module.subnets,"app",null ),"route_table_ids",null) : v.id ]
  db_route_table_ids = [for k,v in lookup(lookup(module.subnets,"db",null ),"route_table_ids",null) : v.id ]
  private_route_table_ids = concat(local.app_route_table_ids , local.db_route_table_ids)

  #Tags
  tags = merge(var.tags , { tf-module = "${var.env}-vpc"},{ env = var.env})


}