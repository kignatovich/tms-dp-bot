  # Terraform
  - create_bucket - праметры для s3 бакета, в которм будет храниться terraform.tfstate от create_infra  (все переменые задаются в файле terraform.tfvars)
  - create_dns - создание зоны DNS для нашего проекта (все переменые задаются в файле terraform.tfvars)
  - create_infra - создание ВМ для разворачивания проекта и выполнение в ней команд по разворачиванию системы CD\CD(все переменые задаются в файле terraform.tfvars, зависит от create_bucket и create_dns)
    
Для удобства файл terraform.tfvars один для create_bucket, create_dns и create_infra. В рельном использовании этого быть не должно, файлы должны быть очищены от лишних переменных. Так же стоит отметить, что для create_bucket и create_dns не используется хранение terraform.tfstate в s3 облаке, в реальном использовании, это должно быть реализовано. 


Описание terraform.tfvars
```shell
#можно получить по ссылке https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token
token  =  "y0_0000000000000000000000000-0_0000000000-0000000000_00000"

cloud_id  = "00000000000000000000" #можно получить по ссылке https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id
folder_id = "00000000000000000000" #можно получить по ссылке https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id 
SQPWD     = "123456789"  #общий пароль вэб авторизации для сервисов jenkins, sonarqube, grafana
SQPNAME   = "MyProject"  #название проекта по умолчанию для sonarqube(переменная нужна для гененрации токена sonarqube)
SQPKEY    = "mykey"   #ключь по умолчанию для sonarqube(переменная нужна для гененрации токена sonarqube)
GITPROJECT = "git@github.com:kignatovich/tms-dp.git" #ссылка на существующий проекта в github
prpass = "0000000000"  #пароль от архива преднастройки ssh ключей ВМ
prpass_url = "https://docs.google.com/uc?export=download&id=1Ga-OAfa000tHq0a000BVOdrGIB9tAPes" #ссылка на заштврованный архив в GC.
prpass_zip = "keyp.zip" #название зашифрованного архива
prpass_file = "prepare.sh" #скрипт установки ssh ключей
login_ghcr = "login_to_ghcr" #логин в ghcr.io 
sname_ghcr = "kignatovich"  #имя юзера в ghcr.io
jenkins_im_ghcr = "jenkins-jcasc:1.2"  #название билда jenkins серврера
tghcr = "ghp_000000000000000000000000000000000000" #api_key от ghcr.io
user_vm = "ubuntu" #пользователь ВМ
d_dns = "devsecops.by."  #имя домена (обязательно с точкой в конце)
dns_a_name = "tms-dp1.devsecops.by." #главная страница проекта (обязательно с точкой в конце)
jenkins_dns_a_name = "jenkins1.devsecops.by." #страница jenkinsa в проекте (обязательно с точкой в конце)
sonar_dns_a_name = "sonarqube1.devsecops.by." #страница sonarqube проекта (обязательно с точкой в конце)
prod_dns_a_name = "prod1.devsecops.by." #страница Prod развертывания проекта (обязательно с точкой в конце)
dev_dns_a_name = "dev1.devsecops.by."  #страница Dev развертывания проекта (обязательно с точкой в конце)
grafana_dns_a_name = "grafana1.devsecops.by." #страница grafana проекта (обязательно с точкой в конце)
prometheus_dns_a_name = "prom1.devsecops.by." #страница prometheus проекта (обязательно с точкой в конце)
cadvisor_dns_a_name = "cad1.devsecops.by."   #страница cadvisor проекта (обязательно с точкой в конце)
static_ip = "0.0.0.0"  #статический IP адрес проекта
```

Запуск (без бота). Переходим в нужную директорию и выполняем:
```shell
terraform plan
```

```shell
terraform apply
```

*Для простоты файлы terraform.tfvars и variables.tf одинаковы в create_infra, create_dns, create_bucket. Из create_dns, create_bucket нужно убрать не спользуемые переменные.
