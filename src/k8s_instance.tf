resource "yandex_compute_instance" "k8s_node" {
  count = 3
  name = "k8s-node-${count.index + 1}"
  zone = "ru-central1-a"
  platform_id = "standard-v1"
  resources {
    memory = 4
    cores   = 4
    core_fraction = 20
  }
  
  boot_disk {
    initialize_params {
      image_id = "fd8j0uq7qcvtb65fbffl"
      size = 50
    }
  }
  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_a.id
    nat        = true
  }

  provisioner "remote-exec" {
    script = "${path.module}/setup.sh"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.network_interface.0.nat_ip_address
  }
  
  metadata = var.metadata["metadata"]
}

output "vm_info" {
  value = {
    for i in yandex_compute_instance.k8s_node : i.name => {
      nat_ip = i.network_interface.0.nat_ip_address
      internal_ip = i.network_interface.0.ip_address
    }
  }
}

