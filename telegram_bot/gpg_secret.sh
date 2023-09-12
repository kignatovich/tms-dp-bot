#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ "$1" == "--create" ]; then
    # Создание пары ключей
    gpg --gen-key
    echo "Ключи созданы."

elif [ "$1" == "--export" ]; then
   # Экспорт ключей
   echo "Введите ID ключа"
   read user_input
   gpg --export -a "$user_input" > $user_input-public.key
   gpg --export-secret-key -a "$user_input" > $user_input-private.key

elif [ "$1" == "--import" ]; then
   # Импорт ключей
   echo "Введите ID ключа"
   read user_input
   gpg --import $user_input-public.key
   gpg --import $user_input-private.key

elif [ "$1" == "--enc" ]; then
    if [ "$2" == "--k" ]; then
        public_key="$3"
        input_file="$4"
        # Шифрование файла с помощью публичного ключа
        gpg --encrypt --recipient-file "$public_key" --output "${input_file}.gpg" "$input_file"
        echo "Файл зашифрован."

    else
        echo "Использование: gpg_secret.sh --enc --k name_public.key /path/to/file"
    fi

elif [ "$1" == "--dec" ]; then
    if [ "$2" == "--k" ]; then
        private_key="$3"
        encrypted_file="$4"

        # Расшифровка файла с помощью приватного ключа
        gpg --decrypt-files "$encrypted_file" > "${encrypted_file%.gpg}_decrypted"
        echo "Файл расшифрован."

    else
        echo "Использование: gpg_secret.sh --dec --k name_private.key /path/to/file"
    fi

elif [ "$1" == "--rcs" ]; then
    if [ "$2" == "--k" ]; then
        private_key="$3"
        directory="$4"

        # Расшифровка всех файлов с расширением .gpg в указанном каталоге и подкаталогах
        find "$directory" -type f -name "*.gpg" | while read encrypted_file; do
            gpg --decrypt-files "$encrypted_file" > "${encrypted_file%.gpg}_decrypted"
            echo "Файл $encrypted_file расшифрован."
        done

    else
        echo "Использование: gpg_secret.sh --rcs --k name_private.key /path/to/folder"
    fi

else
    echo "Использование: "
    echo "gpg_secret.sh --create"
    echo "gpg_secret.sh --enc --k name_public.key /path/to/file"
    echo "gpg_secret.sh --dec --k name_private.key /path/to/file"
    echo "gpg_secret.sh --rcs --k name_private.key /path/to/folder"
    echo "gpg_secret.sh --export //И введите ID ключа"
    echo "gpg_secret.sh --import //И введите ID ключа"
fi
