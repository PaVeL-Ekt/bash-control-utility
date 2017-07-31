#!/usr/bin/env bash

##############################
# Модуль управления проектом #
##############################

set -o nounset
set -o errexit

# Config section
MODULE_PATH="./.manage/module.d/"
LIB_PATH="./.manage/libs/"

. ./.manage/config/env.sh
. ./.manage/config/depends.sh

# Прерывание работы приложения, из-за ошибки приложения.
# @param string message Сообщение, выводимое перед завершением работы приложения.
# @param int    code    Код завершения приложения.
function control.break ()
{
    messages.showError "${1:-"Произошла неизвестая ошибка."}"
    messages.showError "Работа приложения завершена с ошибкой."
    exit ${2:-1}
}

# Завершение работы приложения.
# @param string message Сообщение, выводимое перед завершением работы приложения.
function control.close ()
{
    echo ${1:-""}
    exit 0
}

function control.run_module ()
{
        IDX=0
        local PARAMS
        declare -a PARAMS=()
        for PARAM in "$@"
        do
            if [[ "$IDX" -eq 0 ]]
            then
                MODULE_NAME=$(strings.toLower "$PARAM")
            fi
            if [[ "$IDX" -gt 0 ]]
            then
                PARAMS[$IDX]=$PARAM
            fi
            IDX=$((${IDX} + 1));
        done
        if [[ -n ${MODULE_NAME:-} ]]
        then
            if [[ -f "./.manage/module.d/$MODULE_NAME.sh" ]]
            then
                # Include module
                . "$MODULE_PATH$MODULE_NAME.sh"
                local OUTPUT
                if [[ ${#PARAMS[@]} -ge 1 ]]
                then
                    #. ./.manage/module.d/"$MODULE_NAME".sh ${PARAMS[@]}
                    "$MODULE_NAME.run" ${PARAMS[@]} #| while read ; do echo "$REPLY" ; done
                else
                    #. ./.manage/module.d/"$MODULE_NAME".sh ""
                    "$MODULE_NAME.run" "" #| while read ; do echo "$REPLY" ; done
                fi
            else
                control._commandOrModuleNotFoundException "$MODULE_NAME"
            fi
        else
            control._commandOrModuleNotFoundException "$MODULE_NAME"
        fi
}

function control._commandOrModuleNotFoundException ()
{
    messages.showError "Команда или модуль с именем \"$1\" не найден."
}

function control._showHelp ()
{
    messages.showHeader "Экран помощи"
    if [[ -z ${2:-} ]]
    then
        echo "Доступные команды:"
        for FILE in $(cd "$MODULE_PATH" && ls ./*.sh)
        do
            FILE=$(strings.cut $FILE $(($(strings.length $FILE) - 2)) -1)
            local MODULE=$(strings.cut $FILE $(($(strings.length $FILE) - 3)) 1)
            local OUTPUT=$(strings.pad $MODULE 20 1)"- "
            # include module
            . "$MODULE_PATH$FILE"
            local STDOUT=$("$MODULE.about")
            echo "$OUTPUT$STDOUT"
        done
    else
        echo "methods or module description"
    fi
}

if [[ -z ${1:-} ]]
then
    # HELP section
    control._showHelp
    exit
fi

case $(strings.toLower "$1") in
    help)
        control._showHelp "$@"
        ;;
    *)
        control.run_module "$@"
        ;;
esac
