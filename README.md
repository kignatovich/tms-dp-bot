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

<img width="626" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/c8f31e89-0866-4b84-a54a-3f14b71d0e59">


В боте реализовна проерка на наличие файлов для запуска деплоя.
Файлы наличие которых проверяются: providers.tf, terraform.tfvars, variables.tf, "main.tf.


<img width="615" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/905ee2cf-06ff-4f5e-b489-e969b2e66391">

При успешном развертывании появится ссобщение.

<img width="727" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/d7835e6f-7c87-483a-befd-56603cfd4313">

Так же вы получите сообщение об адресе проекта.

<img width="562" alt="image" src="https://github.com/kignatovich/tms-dp/assets/110161538/1ca3a129-7b13-4d5f-a7cb-ad9999f3ffbb">

Если в процессе развертывания появится ошибка - в чат будет отправлен листинг данной ошибки, для ее последующего устранения и исправления.

*прошу не обращать внимания на время на скриншоте, некоторые функции были включены при последующей работе над проектом.


