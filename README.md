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
### Детали:
На данный момент выполнены:
1. Сайт - машины vm-1 и vm-2 с nginx и балансировщик L7 (доступ по `http://<ip>/80`)
2. Монитроинг - zabbix-server с web-интерфейсом (доступ по `http://<ip>:80/`), zabbix-агенты на всех хостах, сбор метрик. Отсуствует дашборд
3. Логи - отсутствуют
4. Сеть - настроены security groups, на веб-серверах и elasticsearch присутствуют только локальные ip, настроен ssh bastion
5. Резервное копирование - отсутствует

Вывод `terraform state pull` в файле `./tf.state.txt`  
Вывод лога ansible в файле `./ansible.log` [ansible.log](/blob/main/ansible.log) 
Скриншоты:

![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-1.png)
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-2.jpg)
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-3.png)
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-4.png)  
---
### Возникли трудности с мониторингом http подключений  
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/diplom-5.png)


---
На схеме ниже неверно указан сбор метрик zabbix-агентами: они стоят на всех хостах, а не только на веб-серверах.  
![image](https://github.com/Maxterx10/Netology_diplom/blob/main/Infrastructure_scheme.drawio.png?raw=true)


