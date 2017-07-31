#!/usr/bin/env bash
# Указываем библиотеки относительно корня .control
# Для работы необходимы следующие библиотеки из репозитория https://github.com/PaVeL-Ekt/Ext-bash:
# system.sh
# screen.sh
# messages.sh
# strings.sh

LIBS=("system.sh" "screen.sh" "messages.sh" "strings.sh")
HAS_BROKEN=1

for lib in ${LIBS[*]}; do
    if [ ! -f ./.manage/libs/"$lib" ]
    then
        echo "Отсутствует библиотека $lib.";
        HAS_BROKEN=0
    else
        . ./.manage/libs/"$lib"
    fi
done

if [ "$HAS_BROKEN" -eq 0 ]
then
    echo "Продолжение работы невозможно.";
    exit 2;
fi
