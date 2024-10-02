resource "yandex_compute_instance_group" "k8s_node_group" {
  name               = "k8s-node-group"
  folder_id          = var.folder_id
  service_account_id = var.service_account_id
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores         = 4
      memory        = 4
      core_fraction = 20
    }
    boot_disk {
      initialize_params {
        image_id = "fd8j0uq7qcvtb65fbffl"
        size = 50
      }
    }
    network_interface {
      subnet_ids = [yandex_vpc_subnet.subnets["subnet_a"].id]
    }
    scheduling_policy {
      preemptible = true
    }
    labels = {
      role = "k8s-node"
    }
    metadata = var.metadata["metadata"]
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 3
    max_expansion   = 3
  }
  depends_on = [yandex_vpc_route_table.nat_route]
}

resource "yandex_compute_instance" "bastion" {
  name = "bastion"
  zone = "ru-central1-a"
  platform_id = "standard-v1"
  resources {
    memory = 2
    cores   = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
      size = 20
    }
  }

  network_interface {
     subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = var.metadata["metadata"]
}

resource "yandex_vpc_route_table" "nat_route" {
  name                 = "nat_route"
  network_id           = yandex_vpc_network.develop.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.bastion.network_interface.0.ip_address
  }
}



