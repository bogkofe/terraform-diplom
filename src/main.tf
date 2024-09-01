resource "yandex_vpc_network" "develop" {
  name = "develop"
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.3.0/24"]
}

resource "yandex_storage_bucket" "terraform-bucket" {
  access_key        = var.access_key
  secret_key        = var.secret_key
  bucket            = "sagirov-diplom"
  acl               = "private"
  force_destroy     = false
  default_storage_class = "standard"
}

terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "sagirov-diplom"
    region                      = "ru-central1-a"
    key                         = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}