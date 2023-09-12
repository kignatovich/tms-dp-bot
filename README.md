## Состав проекта: 
## - https://github.com/kignatovich/tms-dp - все для создания среды для разработки: ci\cd, мониторинг и тд;
## - https://github.com/kignatovich/tms-dp-bot - телеграмм бот и терраформ;
## - https://github.com/kignatovich/myproject-dp - приложение.

# Настройка сервисной машины(она отвечает за запуск разворачивания инфраструктуры).
В качестве инфрастуктуры используется Yandex Cloud.
Для начала работы с YC нужно в нем зарегистрироваться, создать организацию, каталог, платежный аккаунт, и т.д.
Подробнее [тут](https://cloud.yandex.ru/docs/getting-started/).

## Установка бота
```shell
git clone git@github.com:kignatovich/tms-dp.git
cd tms-dp/
chmode +x ./telegram_bot/instll_bot.sh
sudo ./telegram_bot/install_bot.sh
```
После запуска данной команды, скрипт установит службу бота и запустит ее. 
Cледующим шагом нужно расшифровать секреты (любые файлы с расширением gpg) в нужном каталоге.
В данном репозитории ключа для расшифровки нет.
```bash
chmode +x ./telegram_bot/gpg_secret.sh
chmod 644 ./telegram_bot/tms-dp-private.key
./telegram_bot/gpg_secret.sh --rcs --k ./telegram_bot/tms-dp-private.key ./telegram_bot/terraform/create_infra/
```
Шифрование ассиметричное (шифруется публичным ключом, расшифровывается приватным).

После установки бота, нужно зайти в телеграмм и дать боту команду на установку инфраструктуры.
```bash
/deploy
```

У бота сделана авторизация по telegram_id, если вашего id нету в списке разрешенных, при запуске защищенной команды появится сообщение.

![image](https://github.com/kignatovich/tms-dp-bot/assets/110161538/0f5d176c-ef04-432c-847d-1f180db66470)



В боте реализовна проерка на наличие файлов для запуска деплоя.
Файлы наличие которых проверяются: providers.tf, terraform.tfvars, variables.tf, "main.tf.

![image](https://github.com/kignatovich/tms-dp-bot/assets/110161538/21c89ac0-f555-40c6-9ec4-d39266cf473f)


При успешном развертывании появится ссобщение.

<img width="723" alt="image" src="https://github.com/kignatovich/tms-dp-bot/assets/110161538/f8664ee9-d3c4-404f-ba32-45a3c6d056bc">


Так же вы получите сообщение c адреом проекта.

![image](https://github.com/kignatovich/tms-dp-bot/assets/110161538/ccde305b-04d8-468d-923a-f595accb1c4b)


Если в процессе развертывания появится ошибка - в чат будет отправлен листинг данной ошибки, для ее последующего устранения и исправления.

*прошу не обращать внимания на время на скриншоте, некоторые функции были включены при последующей работе над проектом.


