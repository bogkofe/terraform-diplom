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
