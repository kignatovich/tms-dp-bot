 terraform {
   required_providers {
     yandex = {
       source = "yandex-cloud/yandex"
     }
   }

   backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tf-state-bucket-tms-project"
    region     = "ru-central1-a"
    key        = "terraform/infrastructure1/terraform.tfstate"
    access_key = "0000000000000-0000000"
    secret_key = "0000000000000-000000000000000000000000000"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
 }

provider "yandex" {
   token  =  var.token
   cloud_id  = var.cloud_id
   folder_id = var.folder_id
   zone      = "ru-central1-a"
 }


