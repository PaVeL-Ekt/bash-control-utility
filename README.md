# Bash control utility #

Небольшая модульная утилита, аналог make
В некоторых случаях make слишком ограничен и громоздок, потому я написал данную утилиту.

## Использование ##
Необходимо просто скопировать файлы в проект и создать нужные Вам модули.
Пример модуля test.sh
```
    #!/usr/bin/env bash
    MODULE_STATUS_HEADER="Тестовый модуль"
    function test.about ()
    {
        echo "$MODULE_STATUS_HEADER"
    }
    function status.help ()
    {
        echo "-d    Вывести текущую дату;"
    }
    function status._displayAbout ()
    {
        messages.showHeader "$MODULE_STATUS_HEADER" | while read ; do echo "$REPLY" ; done
    }
    function status._displayHelp ()
    {
        messages.showHeader "$MODULE_STATUS_HEADER" | while read ; do echo "$REPLY" ; done
        echo "Помощь:"
        status.help | while read ; do echo "$REPLY" ; done
    }
    function status.run ()
    {
        if [[ -n ${1:-} ]]
        then
            case $(strings.toLower "$1") in
                "-d")
                    messages.showHeader "$MODULE_STATUS_HEADER"
                    date
                    ;;
                about)
                    status._displayAbout
                    ;;
                *)
                    status._displayHelp
                    ;;
            esac
        else
            echo "Выполняемое по умолчанию действие"
        fi
    }
```
