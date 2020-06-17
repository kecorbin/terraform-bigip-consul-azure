provider "azurerm" {
  version = ">2.0.0"
  features {}
}

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
  number = false
}

locals {
  environment = "${var.prefix}-${random_string.random.result}"
}
