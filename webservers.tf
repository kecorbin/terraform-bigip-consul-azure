
resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = var.admin_username
    admin_password       = random_password.bigippassword.result
    custom_data          = base64encode(file("./templates/webserver.sh"))
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name                      = "terraformnetworkprofile"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.webserver-sg.id
    ip_configuration {
      name      = "IPConfiguration"
      subnet_id = azurerm_subnet.public.id
      primary   = true
    }
  }
}