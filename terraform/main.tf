# Create a resource group if it doesn't exist
terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
  version = ">=2.0"
  # The "feature" block is required for AzureRM provider 2.x.
  features {}
}


resource "azurerm_resource_group" "azvm-rg" {
  location = "westus2"
  name     = "sap-bw-rg-qa"
}

resource "azurerm_virtual_network" "azvnet" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azvm-rg.location
  name                = "sap-bw-vnet-qa"
  resource_group_name = azurerm_resource_group.azvm-rg.name
}

resource "azurerm_subnet" "azsubnet1" {
  name                 = "sap-bw-subnet-qa"
  resource_group_name  = azurerm_resource_group.azvm-rg.name
  virtual_network_name = azurerm_virtual_network.azvnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "aznetworkinterface" {
  location            = azurerm_resource_group.azvm-rg.location
  name                = "sapbwnetintqa"
  resource_group_name = azurerm_resource_group.azvm-rg.name
  ip_configuration {
    name                          = "sapbwnetworkinterfaceip"
    subnet_id                     = azurerm_subnet.azsubnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_windows_virtual_machine" "winvm1" {
  admin_password        = "P@ss2.rd1234"
  admin_username        = "azureuser"
  location              = azurerm_resource_group.azvm-rg.location
  name                  = "sap-bw-vm-qa"
  network_interface_ids = [azurerm_network_interface.aznetworkinterface.id]
  resource_group_name   = azurerm_resource_group.azvm-rg.name
  size                  = "standard_f2"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
