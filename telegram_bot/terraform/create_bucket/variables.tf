variable "SQPWD" {
  description = "sonarqube password"
  type        = string
  }
  
  variable "SQPNAME" {
  description = "project name"
  type        = string
  }

  variable "GITPROJECT" {
  description = "git project url"
  type        = string
  }

  variable "SQPKEY" {
  description = "sonarqube project key"
  type        = string
  }

  variable "token" {
    description = "yandex cloud token"
    type = string
 }

 variable "cloud_id" {
  description = "yandex cloud id"
    type = string
 }

 variable "prpass" {
  description = "passford for prepare"
    type = string
 }
 variable "prpass_url" {
  description = "url for prepare"
    type = string
 }

 variable "prpass_zip" {
  description = "zip for prepare"
    type = string
 }

 variable "prpass_file" {
  description = "file for prepare"
    type = string
 }

 variable "login_ghcr" {
  description = "login ghcr.io"
    type = string
 }

 variable "sname_ghcr" {
  description = "namespace ghcr.io"
    type = string
 }

 variable "jenkins_im_ghcr" {
  description = "jenkins image name ghcr.io"
    type = string
 }

 variable "tghcr" {
  description = "token for ghcr"
    type = string
 }

 variable "folder_id" {
  description = "yandex cloud folder id"
    type = string
 }

 variable "user_vm" {
  description = "username vm"
    type = string
 }

  variable "dns_a_name" {
  description = "dns name project"
    type = string
 }


   variable "d_dns" {
  description = "dns name project"
    type = string
 }

    variable "jenkins_dns_a_name" {
  description = "dns name jenkins"
    type = string
 }


    variable "sonar_dns_a_name" {
  description = "dns name sonarqube"
    type = string
 }


    variable "prod_dns_a_name" {
  description = "dns name prod"
    type = string
 }

     variable "dev_dns_a_name" {
  description = "dns name dev"
    type = string
 }


  variable "static_ip" {
  description = "ip addr"
    type = string
 }