resource "azurerm_network_interface" "consul-nic" {
  name                = "${var.prefix}-consul-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.100"
    public_ip_address_id          = azurerm_public_ip.consul-pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "consul-nic-security" {
  network_interface_id      = azurerm_network_interface.consul-nic.id
  network_security_group_id = azurerm_network_security_group.consul-sg.id
}


resource "azurerm_public_ip" "consul-pip" {
  name                = "${var.prefix}-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${local.environment}-consul"
}

resource "azurerm_linux_virtual_machine" "consul" {
  name                  = "consul-server"
  computer_name         = var.prefix
  admin_username        = var.admin_username
  admin_password        = random_password.bigippassword.result
  location              = var.region
  resource_group_name   = azurerm_resource_group.main.name
  size                  = "Standard_A0"
  custom_data           = base64encode(file("./templates/consul.sh"))
  network_interface_ids = [azurerm_network_interface.consul-nic.id]

  disable_password_authentication = false
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
