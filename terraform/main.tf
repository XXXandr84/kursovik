terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
#  version                  = 0.35
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "ubuntu-image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "k8s" {
  name  = "k8s-${count.index}"
  count = var.instance_count
##
timeouts {
    create = "15m"
    update = "5m"
    delete = "10m"
  }
##
  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      #image_id = var.image_id
      image_id = data.yandex_compute_image.ubuntu-image.image_id
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

locals {
  names = yandex_compute_instance.k8s.*.name
  ips   = yandex_compute_instance.k8s.*.network_interface.0.nat_ip_address
}
###
resource "local_file" "manifest" {
  content = templatefile("manifest.tpl",
    {
      #k8s_hosts = yandex_compute_instance.k8s.*.network_interface.0.nat_ip_address
      names = local.names,
      addrs = local.ips,
    }
  )
  filename = "../manifest.sh"
}
###

###
resource "local_file" "prometheus" {
  content = templatefile("prometheus.tpl",
    {
      #k8s_hosts = yandex_compute_instance.k8s.*.network_interface.0.nat_ip_address
      names = local.names,
      addrs = local.ips,
    }
  )
  filename = "../ansible/roles/prometheus/files/prometheus.yml"
}
###
# Invetrory for ansible and run playbook 
resource "local_file" "inventory" {
  content = templatefile("inventory.tpl",
    {
      #k8s_hosts = yandex_compute_instance.k8s.*.network_interface.0.nat_ip_address
      names = local.names,
      addrs = local.ips,
    }
  )
  filename = "../ansible/inventory.ini"

  provisioner "local-exec" {
    command     = "sleep 90 && ansible-playbook -i inventory.ini k8s_playbook.yml"
    working_dir = "../ansible"
  }
###
#  provisioner "file" {
#    source      = "files/script.sh"
#    destination = "/home/ubuntu/script.sh"
#  }
#resource "null_resource" "script_file" {
#  provisioner "local-exec" {
#    command = "bash /home/ubuntu/script.sh"
#  }
###
}  
################################
#resource "script_kub" "file" {
#  provisioner "file" {
#    source      = "files/script.sh"
#    destination = "/home/ubuntu/script.sh"
#  }
#resource "null_resource" "script_file" {
#  provisioner "local-exec" {
#    command = "bash /home/ubuntu/setup.sh"
#  }
#}
################################
#}
