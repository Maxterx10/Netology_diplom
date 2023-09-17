# Netology диплом
  
### Работа выполнялась на Debian 11  
  
### Для создания инфраструктуры нужно:
1. Клонировать этот репозиторий
2. Установить Terraform >= v0.13, скопировать файл `.terraformrc` из репозитория в директорию пользователя `~/`
3. Установить Ansible >= v5 c ansible-core >= v2.12
4. Сгенерировать ssh-key, вставить публичный ключ в `./terraform/meta.txt`
5. Сгенирировать OAuth-токен в yandex cloud, вставить его в `./terraform/token.tf`
6. Вставить `cloud_id` и `folder_id` из yandex cloud в `./terraform/main.tf`
7. Находясь в директории `./terraform/` запустить `terraform apply`, дождаться завершения развертывания чистой инфраструктуры
8. Находясь в директории `./ansible/` запустить `ansible-playbook master_playbook.yml`
9. Инфраструктура развернута!

---
### Исправления:  

#### Terraform

1. Oauth-токен теперь задаю через параметр `-var "yc_token="`
2. Заполнил файл `.gitignore`
3. Веб-сервера теперь создаются через цикл for_each, список имен веб-серверов задается в файле `./terraform/vm_list.tf`
4. Target group теперь создается через блок dynamic
5. В templates остался только inventory-файл

#### Ansible

1. Вместо переменных, создаваемых через templates terraform'а, используются переменные hostvars, если это возможно
2. Расширено использование модуля templates, вместо связки "terraform local_files => ansible files" (Ранее в ansible уже был использован модуль templates)
3. (Плейбуки на бастион никогда не копировались. ProxyCommand для бастиона использовался изначально)
4. Теперь Zabbix-хосты добавляются через ansible loop
5. Файлы переменных, содержащие пароли, теперь зашифрованы через ansible-vault

---
### Детали:
На данный момент выполнены:
1. Сайт - машины vm-* с nginx и балансировщик L7 (доступ по `http://<alb_ip>:80/`)
2. Монитроинг - zabbix-server с web-интерфейсом (доступ по `http://<zabbix_server_ip>:80/`), zabbix-агенты на всех хостах, сбор метрик. Отсуствует дашборд
3. Логи - отсутствуют
4. Сеть - настроены security groups, на веб-серверах и elasticsearch присутствуют только локальные ip, настроен ssh bastion
5. Резервное копирование - отсутствует

---
### Подтверждение работы ресурса:  
Вывод `terraform state pull` в файле [`./tf.state.txt`](/tf.state.txt)  
Вывод лога ansible в файле [`./ansible.log`](/ansible.log)  

Скриншоты:  
Подключение к веб-серверам через балансировщик:  

![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-1.png)

![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-2.jpg)

Zabbix frontend:  
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-3.png)

Zabbix hosts:  
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-4.png)  


---
На схеме ниже неверно указан сбор метрик zabbix-агентами: они стоят на всех хостах, а не только на веб-серверах.  
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/Infrastructure_scheme.drawio.png?raw=true)


