provider "azurerm" {
  version = ">2.0.0"
  features {}
}

locals {
  environment = "${var.prefix}-demo"
}
# Create a resource group 
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.region

  tags = {
    environment = local.environment
  }
}

# Create virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.cidr]
  location            = "centralus"
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = local.environment
  }
}

# Create public/external subnet
resource "azurerm_subnet" "public" {
  name                 = "${var.prefix}-public"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}
