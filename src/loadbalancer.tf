resource "yandex_lb_target_group" "k8s-target-group" {
  name      = "k8s-target-group"
  region_id = "ru-central1"

  target {
    address     = yandex_compute_instance_group.k8s_node_group.instances[0].network_interface[0].ip_address
    subnet_id   = yandex_vpc_subnet.subnets["subnet_a"].id
  }

    target {
    address     = yandex_compute_instance_group.k8s_node_group.instances[1].network_interface[0].ip_address
    subnet_id   = yandex_vpc_subnet.subnets["subnet_a"].id
  }

    target {
    address     = yandex_compute_instance_group.k8s_node_group.instances[2].network_interface[0].ip_address
    subnet_id   = yandex_vpc_subnet.subnets["subnet_a"].id
  }
}

resource "yandex_lb_network_load_balancer" "k8s_lb" {
  name = "k8s-lb"

  listener {
    name = "http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name = "https"
    port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-target-group.id
    healthcheck {
      name                = "http-health-check"
      http_options {
        port     = 80
        path     = "/"
      }
    }
  }
}