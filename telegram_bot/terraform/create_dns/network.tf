resource "yandex_dns_zone" "zone2" {
  name        = "my-public-zone"
  description = "devsc"

  labels = {
    label1 = "label-1-value"
  }

  zone             = var.d_dns
  public           = true

}

resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]

}

resource "yandex_dns_recordset" "rs2" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "www.${var.dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
}

resource "yandex_dns_recordset" "rs3" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.jenkins_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]

}


resource "yandex_dns_recordset" "rs4" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "www.${var.jenkins_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
}

resource "yandex_dns_recordset" "rs5" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.sonar_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
 
}


resource "yandex_dns_recordset" "rs6" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "www.${var.sonar_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]

}

resource "yandex_dns_recordset" "rs7" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.prod_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
}


resource "yandex_dns_recordset" "rs8" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "www.${var.prod_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
}

resource "yandex_dns_recordset" "rs9" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.dev_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]

}


resource "yandex_dns_recordset" "rs10" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "www.${var.dev_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"] 
}


resource "yandex_dns_recordset" "rs11" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.grafana_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
  
}
  
  
resource "yandex_dns_recordset" "rs12" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "www.${var.grafana_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
}


resource "yandex_dns_recordset" "rs13" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.prometheus_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
  
}
  
 
resource "yandex_dns_recordset" "rs14" {
  zone_id = yandex_dns_zone.zone2.id   
  name    = "www.${var.prometheus_dns_a_name}"
  type    = "A"
  ttl     = 60 
  data    = ["${var.static_ip}"]
} 

resource "yandex_dns_recordset" "rs15" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "${var.cadvisor_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
  
} 
 
  
resource "yandex_dns_recordset" "rs16" {
  zone_id = yandex_dns_zone.zone2.id
  name    = "www.${var.cadvisor_dns_a_name}"
  type    = "A"
  ttl     = 60
  data    = ["${var.static_ip}"]
} 
