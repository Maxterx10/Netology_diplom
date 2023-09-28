# Netology диплом
  
### Работа выполнялась на Debian 11  
  
### Для создания инфраструктуры нужно:
1. Клонировать этот репозиторий
2. Установить Terraform >= v0.13, скопировать файл `.terraformrc` из репозитория в директорию пользователя `~/`
3. Установить Ansible >= v5 c ansible-core >= v2.12
4. Сгенерировать ssh-key, вставить публичный ключ в `./terraform/meta.txt`
5. Вставить `cloud_id` и `folder_id` из yandex cloud в `./terraform/main.tf`
6. Задать в переменной `vm_list` (можно в файле `./vm_list.tf`) список имен web-серверов. От длины списка зависит их число, но не более 9 в связи с квотами Яндекса на число ВМ в одном облаке
7. Сгенирировать OAuth-токен в yandex cloud, вставить его в `./terraform/token.tf` или при выполнении п.7 добавить флаг `-var "yc_token=<mytoken>"`
8. Находясь в директории `./terraform/` запустить `terraform apply`, дождаться завершения развертывания чистой инфраструктуры
9. Находясь в директории `./ansible/` запустить `ansible-playbook ansible_playbook.yml` для загрузки всех необходимых ролей и коллекций
10. Находясь в директории `./ansible/` запустить `ansible-playbook master_playbook.yml --vault-password-file <файл содержащий пароль "1111">`
11. Инфраструктура развернута!

---
### Детали:

1. Сайт - хосты <vm_list> с Nginx и балансировщик L7 (доступ по `http://<alb_ip>:80/`)
2. Монитроинг - Zabbix server с web-интерфейсом (доступ по `http://<zabbix_server_ip>:80/`) на отдельной ВМ; Zabbix агенты на всех хостах; сбор метрик, дашборды, триггеры - через присвоение хостам стандартных темплейтов
3. Логи - Filebeat на web-серверах, Elasticsearch и Kibana на собственных ВМ; Сбор логов Filebeat'ом через стандартный input модулей Nginx и System; Дашборды в Kibana включены через конфиг Filebeat'а
4. Сеть - настроены security groups, на веб-серверах и elasticsearch присутствуют только локальные ip, настроен ssh bastion
5. Резервное копирование - снэпшоты на все диски создаются раз в день и хранятся 168 часов.

---
### Исправления:  

#### Terraform

1. Oauth-токен теперь задается через параметр `-var "yc_token="`
2. Заполнен файл `.gitignore`
3. Веб-сервера теперь создаются через цикл for_each, список имен веб-серверов задается в файле `./terraform/vm_list.tf`
4. Target group теперь создается через блок dynamic
5. Через local_file теперь создается только inventory-файл, чтобы не смешивать создание и настройку инфраструктуры

#### Ansible

1. Вместо переменных, создаваемых через templates terraform'а, используются переменные hostvars, если это возможно
2. Расширено использование модуля templates, вместо связки "terraform local_files => ansible files" (Ранее в ansible уже был использован модуль templates)
3. (Плейбуки на бастион никогда не копировались. ProxyCommand для бастиона использовался изначально)
4. Теперь Zabbix-хосты добавляются через ansible loop
5. Файлы переменных, содержащие пароли, теперь зашифрованы через ansible-vault

#### ELK

1. Filebeat на web-серверах, а также elasticsearch и kibana на собственных хостах поднимаются в докер-контейнерах
2. В конфиге filebeat включены только модуль nginx, собирающий access_log и error_log, модуль system и dashboards
3. Стандартные дашборды [Filebeat Nginx] Overview ECS и [Filebeat Nginx] Access and error logs ECS включются через web GUI (можно воспользоваться встроенным поиском)

#### Снэпшоты

1. Снэпшоты на все диски создаются раз в день и хранятся 168 часов.

---

### Подтверждение работы ресурса:  
Вывод `terraform state pull` в файле [`./tf.state.txt`](/tf.state.txt)  
Вывод лога ansible в файле [`./ansible.log`](/ansible.log)  

Скриншоты:  

---
На схеме ниже неверно указан сбор метрик zabbix-агентами: они стоят на всех хостах, а не только на веб-серверах.  
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/Infrastructure_scheme.drawio.png?raw=true)


