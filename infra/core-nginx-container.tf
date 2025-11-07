# resource "random_password" "nginx_container" {
#   length  = 20
#   special = false
# }

# resource "proxmox_virtual_environment_container" "nginx" {
#   node_name     = var.PROXMOX_NODE
#   vm_id         = 100
#   tags          = ["core"]
#   start_on_boot = true
#   unprivileged  = true

#   cpu {
#     cores = 2
#   }

#   memory {
#     dedicated = 2048
#   }

#   network_interface {
#     name = "veth0"
#   }

#   disk {
#     datastore_id = "local-lvm"
#     size         = 20
#   }

#   operating_system {
#     template_file_id = proxmox_virtual_environment_download_file.alma.id
#     type             = "ubuntu"
#   }

#   initialization {
#     hostname = "nginx"

#     ip_config {
#       ipv4 {
#         address = "192.168.3.101/24"
#         gateway = "192.168.3.1"
#       }
#     }

#     user_account {
#       keys     = [trimspace(tls_private_key.core.public_key_openssh)]
#       password = random_password.nginx_container.result
#     }
#   }

#   connection {
#     agent       = false
#     type        = "ssh"
#     user        = "root"
#     private_key = trimspace(tls_private_key.core.private_key_openssh)
#     host        = "192.168.3.101"
#   }

#   provisioner "file" {
#     destination = "/root/install_nginx.sh"
#     source      = "scripts/install_nginx.sh"
#   }

#   provisioner "remote-exec" {
#     inline = ["sh /root/install_nginx.sh"]
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }
