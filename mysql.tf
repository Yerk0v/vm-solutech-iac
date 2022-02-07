resource "azurerm_mysql_server" "solutech-mysql-db" {
  name                = "solutechdb"  //  definir nombre de la base de datos
  location            = var.location  // variable location almacena la ubicación
  resource_group_name = azurerm_resource_group.rsc-group.name // grupo de recursos 

  administrator_login          = "yerkoadmin" // nombre del administrador 
  administrator_login_password = "NSc3URaJGzJxw2fA" 

  sku_name   = "B_Gen5_2"
  storage_mb =  8192 // Almacenamiento en MB
  version    = "5.7"  // Versión, en este caso es 5.7 porque la 8.0.27 no es compatible.

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}