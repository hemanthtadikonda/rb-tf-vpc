locals {
  # Subnets
  public_subnets_id = [for k,v in lookup(lookup(module.subnets,"public",null ),"subnets_ids",null) : v.id ]
  app_subnets_id = [for k,v in lookup(lookup(module.subnets,"app",null ),"subnets_ids",null) : v.id ]
  db_subnets_id = [for k,v in lookup(lookup(module.subnets,"db",null ),"subnets_ids",null) : v.id ]
  private_subnet_id = concat(local.app_subnets_id , local.db_subnets_id)

  # RT


}