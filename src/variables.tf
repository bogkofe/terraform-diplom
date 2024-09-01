###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "access_key" {
  type        = string
  description = "yandex_iam_service_account_static_access_key"
}

variable "secret_key" {
  type        = string
  description = "yandex_iam_service_account_static_secret_key"
}

variable "service_account_id" {
  type        = string
  description = "service_account_id"
}

variable "private_key_path" {
  description = "Путь к приватному ключу SSH"
  type        = string
  default     = "/home/admins/.ssh/id_rsa"
}

variable "metadata" {
  type = map(object({
    serial-port-enable  = number
    ssh-keys            = string
  }))
  default = {
    metadata = {
      serial-port-enable = 1
      ssh-keys         = "admins:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8hSq3x1m8WIuqKY5kuU70v6+h49Qh8lsr+5cZ6Ow84nxpsg8LTNjBTmFcROJ6kXRc/Eh/RWtCQLahFsZ8bmNseipqF8Jp87Y9ImL4czW3Ufhd50wFxeMFtZKH7zyFXE9y+cTmP8oosJml0XkllWh25/OT+Y0mxG08G7DF7eT0p9KLlUXne1Ezc1SY6Ncpuw0UVhyYTT9Qq8FFRI86CMxAXwooZ8E9PeLB4AUjlyqjHv6vwUa1GVWcuu3UTrFXz1hy/BgH1bWjgVdUr6P4FnAQdCxHE9B8FP6efOfBH1v9zdc0b5JxQg8J6O6BMeCw+A7POHtiSvkHjvwjksBZpXbMAGiU9t0V/OpilVHUnZqeEvkNUEbX6BHkcg6Zo2OwOgrHKDii3c01WT6ZTFbOx0bS3LmcLCXqkaZkqE5MQL6GEnMcWtib9O5URTbHmNgAYBij8eAOJQyjXbJ5vr+YBHpmbUZr9lmNSMkWNQk32nE6szS+7QhRzj8ziqjSJvtEKKM= admins@s1"
    }
  }
}

