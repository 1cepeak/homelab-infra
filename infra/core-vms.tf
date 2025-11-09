locals {
  vms = [
    {
      name      = "nginx"
      id        = 1000
      cores     = 2
      memory    = 2048
      disk_size = 10
      network = {
        bridge  = "vmbr0"
        address = "192.168.3.68/24"
        gateway = "192.168.3.1"
      }
    }
  ]
}

resource "random_password" "core_vm_password" {
  length  = 20
  special = false
}

resource "tls_private_key" "core_vm_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "core_vm_password" {
  value       = random_password.core_vm_password.result
  description = "Core VMs password"
  sensitive   = true
}

output "core_vm_private_key" {
  value       = tls_private_key.core_vm_private_key.private_key_pem
  description = "Core VMs private key"
  sensitive   = true
}

resource "local_file" "core_vm_local_private_key" {
  content         = tls_private_key.core_vm_private_key.private_key_openssh
  filename        = pathexpand("~/.ssh/core_vm")
  file_permission = "0600"
}

resource "local_file" "core_vm_local_public_key" {
  content         = tls_private_key.core_vm_private_key.public_key_openssh
  filename        = pathexpand("~/.ssh/core_vm.pub")
  file_permission = "0600"
}

resource "proxmox_virtual_environment_file" "core_vm_cfg" {
  count        = length(local.vms)
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE

  source_raw {
    file_name = "${local.vms[count.index].name}-vm.cloud-config.yaml"
    data = templatefile("templates/almalinux.cloud-config.tfpl", {
      hostname       = local.vms[count.index].name
      password       = random_password.core_vm_password.result
      ssh_public_key = tls_private_key.core_vm_private_key.public_key_openssh
    })
  }
}

resource "proxmox_virtual_environment_vm" "core_vm" {
  count     = length(local.vms)
  name      = local.vms[count.index].name
  vm_id     = local.vms[count.index].id
  node_name = var.PROXMOX_NODE
  tags      = ["core"]

  agent {
    enabled = true
  }

  cpu {
    cores = local.vms[count.index].cores
    type  = "host"
  }

  memory {
    dedicated = local.vms[count.index].memory
  }

  network_device {
    bridge = local.vms[count.index].network.bridge
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    size         = local.vms[count.index].disk_size
    file_id      = proxmox_virtual_environment_download_file.almalinux_9_import.id
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = local.vms[count.index].network.address
        gateway = local.vms[count.index].network.gateway
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.core_vm_cfg[count.index].id
  }
}
