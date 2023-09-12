#!/bin/bash
current_dir=$(pwd)
TRF=terraform_1.4.6_linux_amd64.zip
apt update
apt upgrade -y
apt install unzip python3-pip gnupg
wget https://hashicorp-releases.yandexcloud.net/terraform/1.4.6/$TRF
unzip $TRF -d ./
mv ./terraform /usr/local/bin/
pip3 install python-telegram-bot
PATH1=$(readlink -f ./telegram_bot/tgbot.py)
PATH2="${current_dir}/telegram_bot/"
sed -i "s|PATH_TO_FILE|$PATH1|g" ./telegram_bot/tgbp.service
sed -i "s|PRPATH|$PATH2|g" ./telegram_bot/tgbot.py
cp ./telegram_bot/tgbp.service /etc/systemd/system/
systemctl daemon-reload
echo "Активируем службу"
systemctl enable tgbp.service
echo "Запускаем службу"
systemctl start tgbp.service
