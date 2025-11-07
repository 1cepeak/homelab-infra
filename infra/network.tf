resource "proxmox_virtual_environment_sdn_zone_simple" "zone1" {
  id    = "zone1"
  nodes = [var.PROXMOX_NODE]
  ipam  = var.PROXMOX_NODE

  depends_on = [
    proxmox_virtual_environment_sdn_applier.finalizer
  ]
}

resource "proxmox_virtual_environment_sdn_vnet" "vnet1" {
  id   = "vnet1"
  zone = proxmox_virtual_environment_sdn_zone_simple.zone1.id

  depends_on = [
    proxmox_virtual_environment_sdn_applier.finalizer
  ]
}

resource "proxmox_virtual_environment_sdn_subnet" "vnet1_subnet" {
  cidr    = "192.168.5.0/24"
  gateway = "192.168.5.1"
  vnet    = proxmox_virtual_environment_sdn_vnet.vnet1.id
  snat    = true

  dhcp_range = {
    start_address = "192.168.5.2"
    end_address   = "192.168.5.254"
  }

  depends_on = [
    proxmox_virtual_environment_sdn_applier.finalizer
  ]
}


resource "proxmox_virtual_environment_sdn_applier" "subnet_applier" {
  depends_on = [
    proxmox_virtual_environment_sdn_zone_simple.zone1,
    proxmox_virtual_environment_sdn_vnet.vnet1,
    proxmox_virtual_environment_sdn_subnet.vnet1_subnet
  ]
}

resource "proxmox_virtual_environment_sdn_applier" "finalizer" {
}
