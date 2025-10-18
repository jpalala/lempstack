provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "lemp-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "lemp-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "lemp-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "lemp-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name                = "lemp-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "lemp-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  network_interface_ids = [azurerm_network_interface.nic.id]
}

# ------------------------------------
# 🔧 Bootstrap via Provisioners
# ------------------------------------

# Copy docker-compose.yml from your local directory (create it beside main.tf)
provisioner "file" {
  source      = "docker-compose.yml"
  destination = "/home/azureuser/docker-compose.yml"

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.pip.ip_address
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
  }
}

# Copy OTEL compose
provisioner "file" {
  source      = "docker-compose.otel.yml"
  destination = "/home/azureuser/docker-compose.otel.yml"

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.pip.ip_address
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
  }
}

# Copy OTEL config
provisioner "file" {
  source      = "otel-config.yaml"
  destination = "/home/azureuser/otel-config.yaml"

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.pip.ip_address
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
  }
}

# Start OTEL stack
provisioner "remote-exec" {
  inline = [
    "cd /home/azureuser && sudo docker compose -f docker-compose.otel.yml up -d"
  ]

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.pip.ip_address
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
  }
}


# Install Docker & start stack
provisioner "remote-exec" {
  inline = [
    "sudo apt update",
    "curl -fsSL https://get.docker.com | sh",
    "sudo usermod -aG docker azureuser",
    "sudo apt install -y docker-compose-plugin",
    "cd /home/azureuser && sudo docker compose up -d"
  ]

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.pip.ip_address
    user        = "azureuser"
    private_key = file("~/.ssh/id_rsa")
  }
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}
