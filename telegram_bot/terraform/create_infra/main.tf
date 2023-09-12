resource "yandex_vpc_network" "network-1" {
  name = "from-terraform-network"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "from-terraform-subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["10.2.0.0/16"]
}

resource "yandex_vpc_security_group" "sg-01" {
  name        = "Security group for VM-1"
  network_id  = "${yandex_vpc_network.network-1.id}"

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "vm-1" {
  name = "infra-vm"
  platform_id = "standard-v1"
  zone = "ru-central1-a"
  
 
  resources {
    cores  = 4  
    memory = 8
  }
 
  boot_disk {
    initialize_params {
      size = 200
      image_id = "fd8bkgba66kkf9eenpkb"
      #fd8n6sult0bipcm75u12
      type     = "network-ssd"
    }
  }

 
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    nat_ip_address = var.static_ip
    security_group_ids = [yandex_vpc_security_group.sg-01.id]
  }

  
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  

  provisioner "remote-exec" {
    inline = [ 
      # отключение сообщений ubuntu о том что нужно перезапустить службы после установки какого то либо пакета и сообщенеи что есть новая версия ядра
      "echo \"\\$nrconf{restart} = 'a'\" | sudo tee -a /etc/needrestart/needrestart.conf",
      "echo \"\\$nrconf{kernelhints} = 0\" | sudo tee -a /etc/needrestart/conf.d/silence_kernel.conf",
      "sudo timedatectl set-timezone Europe/Minsk",
      # обновляем и устанавливаем нужные программы
      "sudo apt update",
      "sudo apt install -y docker.io nginx unzip git docker-compose",
      "sudo snap install core",
      "sudo snap refresh core",
      "sudo snap install --classic certbot",
      "sudo ln -s /snap/bin/certbot /usr/bin/certbot",
      "sudo systemctl enable docker",
      "wget https://github.com/aquasecurity/trivy/releases/download/v0.44.1/trivy_0.44.1_Linux-64bit.deb",
      "sudo dpkg -i trivy_0.44.1_Linux-64bit.deb",
      "echo ${var.dns_a_name} > nginx_projeckt_url",
      "echo ${var.jenkins_dns_a_name} > nginx_jenkins_url",
      "echo ${var.sonar_dns_a_name} > nginx_sonarqube_url",
      "echo ${var.prod_dns_a_name} > nginx_prod_url",
      "echo ${var.dev_dns_a_name} > nginx_dev_url",
      "echo ${var.grafana_dns_a_name} > nginx_grafana_url",
      "echo ${var.prometheus_dns_a_name} > nginx_prometheus_url",
      "echo ${var.cadvisor_dns_a_name} > nginx_cadvisor_url",
      # скрипт преподготовки вм
      "wget --no-check-certificate '${var.prpass_url}' -O ${var.prpass_zip}",
      "unzip -P ${var.prpass} ${var.prpass_zip}",
      "sudo ./${var.prpass_file}",
      "sudo rm ./${var.prpass_zip} ./${var.prpass_file}",
      # клонируем проект с нашей инфраструктурой
      "echo yes | git clone ${var.GITPROJECT}",
      "sudo chmod +x ./tms-dp/infra/jenkins/telegram.sh",
      "sudo chmod +x ./tms-dp/infra/gpg_secret.sh",
      "sudo chmod +x ./tms-dp/infra/check_resource.sh",
      "sudo chmod 644 ./tms-dp/tms-infra-private.key",
      "sudo ./tms-dp/infra/gpg_secret.sh --rcs --k ./tms-dp/tms-infra-private.key ./tms-dp/",
      
      #установка мониторинга

      "sudo docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions",
      "sudo cp ./tms-dp/infra/daemon.json /etc/docker/",
      "sudo systemctl restart docker",
      #установка локи
      "sudo chmod +x ./tms-dp/infra/loki.sh",
      "sudo ./tms-dp/infra/loki.sh",
      "sed -i -e \"s/0.0.0.0/${yandex_compute_instance.vm-1.network_interface.0.ip_address}/g\" ./tms-dp/infra/monitoring/grafana/provisioning/datasources/datasource.yml",
      "sed -i -e \"s/1234567890/${var.SQPWD}/g\" ./tms-dp/infra/monitoring/docker-compose.yml",
      "sudo docker-compose -f ./tms-dp/infra/monitoring/docker-compose.yml up -d",
      # усатнвока sonar qube
      "sudo docker run -d --restart always --name sonarqube -p 9000:9000 -p 9092:9092 -v sonarqube-conf:/opt/sonarqube/conf -v sonarqube-data:/opt/sonarqube/data -v sonarqube-logs:/opt/sonarqube/logs -v sonarqube-extensions:/opt/sonarqube/extensions sonarqube",
    
      # добавить скрипт проверки доспуногсти ресурса(ищем ответ 200 и текст на старнице)
      "./tms-dp/infra/check_resource.sh http://localhost:9000 SonarQube",
      # меняем стандартный пароль сонара на наш и файла с переменными
      "curl -u admin:admin -X POST \"http://localhost:9000/api/users/change_password?login=admin&previousPassword=admin&password=${var.SQPWD}\"",
      # создаем проект кей и дефолтный проект
      "curl -X POST -u admin:${var.SQPWD} \"http://localhost:9000/api/projects/create?project=${var.SQPKEY}&name=${var.SQPNAME}\"",
      # генерируем токен и отправляем его в папку где будет собирваться jenkins, так же корректируем файл настроек sonarqbe
      "curl -X POST -u admin:${var.SQPWD} \"http://localhost:9000/api/user_tokens/generate\" -d \"name=${var.SQPNAME}&login=admin&projectKey=${var.SQPKEY}\" | grep -o '\"token\":\"[^\"]*' | cut -d'\"' -f4 > ./tms-dp/infra/jenkins/token",
      "sudo echo sonar.host.url=http://${yandex_compute_instance.vm-1.network_interface.0.ip_address}:9000 >> ./tms-dp/infra/jenkins/sonar-scanner.properties",
    
      # заменяем пароль администратора 1234 на наш пароль, заменяем IP адрес для вэбхуков на наш внешний адрес
      "sed -i -e \"s/1234/${var.SQPWD}/g\" ./tms-dp/infra/jenkins/jenkins-casc.yaml",
      "sed -i -e \"s/X.X.X.X/${yandex_compute_instance.vm-1.network_interface.0.ip_address}/g\" ./tms-dp/infra/jenkins/ansible/hosts_dev",
      "sed -i -e \"s/X.X.X.X/${yandex_compute_instance.vm-1.network_interface.0.ip_address}/g\" ./tms-dp/infra/jenkins/ansible/hosts_main",
      
      # установка nginx и сопутсвующих программ
      "sudo chmod +x ./tms-dp/infra/nginx.sh",
      "sudo ./tms-dp/infra/nginx.sh",
      # авторизовываемся в хранилище github
      "export CR_PAT=${var.tghcr}",
      #"export CR_PAT=$(cat ./tms-dp/infra/jenkins/github)",
      "echo $CR_PAT | sudo docker login ghcr.io -u ${var.login_ghcr} --password-stdin",
      # билдим образ дженкинса
      "sudo docker build -t ghcr.io/${var.sname_ghcr}/${var.jenkins_im_ghcr} ./tms-dp/infra/jenkins/",
      "sudo docker push ghcr.io/${var.sname_ghcr}/${var.jenkins_im_ghcr}",
      # запускаем контейнер с дженкинсом
      "sudo docker run -d --restart always --name jenkins -p 8080:8080 ghcr.io/${var.sname_ghcr}/${var.jenkins_im_ghcr}",
      # отправляем его(артефакт) в хранилище github 
      "./tms-dp/infra/jenkins/telegram.sh 'Ресурс достпен по адресу - https://${var.dns_a_name}'",
      "./tms-dp/infra/jenkins/telegram.sh 'Внешний IP адрес - ${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}'",

      
    ]
  }

  connection {
    type        = "ssh"
    #user        = "ubuntu"
    user = var.user_vm
    private_key = file("~/.ssh/id_rsa")
    host        = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
  }


}


output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
 
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
} 

output "project_domain_name" {
  value = var.dns_a_name
} 
