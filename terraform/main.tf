#main.tf
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
  token = var.yc_token #from ./token.tf
  cloud_id = "b1gjtjq1clm93sgdi59k"
  folder_id = "b1g3qp4v82uf78n684iu"
}
