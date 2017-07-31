#!/usr/bin/env bash
# Стандартные значения передаваемых переменных
TEST_ENV="ТЕСТОВАЯ ПЕРЕМЕННАЯ"

# Подключим файл с локальными значениями переменных
if [ -f "./.manage/config/env_local.sh" ]
then
    . ./.manage/config/env_local.sh
fi

# Экспорт настроек
export TEST_ENV
