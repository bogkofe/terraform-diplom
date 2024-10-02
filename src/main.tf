resource "yandex_vpc_network" "develop" {
  name = "develop"
}

locals {
  subnets = {
    subnet_a = {
      name = "subnet-a"
      zone = "ru-central1-a"
      cidr = "10.0.1.0/24"
    }
    subnet_b = {
      name = "subnet-b"
      zone = "ru-central1-b"
      cidr = "10.0.2.0/24"
    }
    subnet_d = {
      name = "subnet-d"
      zone = "ru-central1-d"
      cidr = "10.0.3.0/24"
    }
  }
}

resource "yandex_vpc_subnet" "subnets" {
  for_each       = local.subnets
  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [each.value.cidr]
#  route_table_id = yandex_vpc_route_table.nat_route.id
}

# resource "yandex_vpc_subnet" "public" {
#   name           = "public"
#   zone           = "ru-central1-a"
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = ["10.0.4.0/24"]
# }