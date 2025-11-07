resource "proxmox_virtual_environment_download_file" "almalinux_9_vztmpl" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE
  url          = "http://download.proxmox.com/images/system/almalinux-9-default_20240911_amd64.tar.xz"
}

resource "proxmox_virtual_environment_download_file" "almalinux_9_import" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE
  url          = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
  file_name    = "AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
}
