
# Se crea el grupo de recursos

resource "azurerm_resource_group" "rsc-group" {  
    name = var.resource-group-name
    location = var.location 
}

# Configuramos la VM

resource "azurerm_virtual_machine" "vm-azure" {
    name                  = "${var.prefix}-vm"
    location              = var.location
    resource_group_name   = azurerm_resource_group.rsc-group.name
    network_interface_ids = [azurerm_network_interface.network-instance.id]
    vm_size               = "Standard_D1_v2"

# Configuramos los discos para que se eliminen una vez aplicado terraform destroy

delete_os_disk_on_termination = true  
delete_data_disks_on_termination = true

#Se especifica la version de OS 

 storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest" // especificar la version 
} 

 storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
}

#Perfil del OS (Con contraseña)

 os_profile {
    computer_name   = "default-pc"
    admin_username  = "yerko"
    admin_password  = "230413!"
} 

#Llave SSH

 os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        key_data = file("mykey.pub")
        path     = "/home/yerko/.ssh/authorized_keys"
    }
 } 
}

resource "azurerm_network_interface" "network-instance" {
    name                      = "${var.prefix}-instance1"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.rsc-group.name
    #network_security_group_id = azurerm_network_security_group.allow-ssh.id

    ip_configuration {
        name                          = "instance1"
        subnet_id                     = azurerm_subnet.subnet-internal.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.public-ip-instance.id
    }
}

resource "azurerm_subnet" "subnet-internal" {
    name                 = "${var.prefix}-internal-1"
    resource_group_name  = azurerm_resource_group.rsc-group.name
    virtual_network_name = azurerm_virtual_network.vtn-1.name
    address_prefixes       = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "public-ip-instance" {
    name                        = "instance1-public-ip"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.rsc-group.name
    allocation_method           = "Dynamic"
}
