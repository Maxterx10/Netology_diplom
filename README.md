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
1. Сайт - машины vm-1 и vm-2 с nginx и балансировщик L7
2. Монитроинг - zabbix-server с web-интерфейсом, zabbix-агенты на всех хостах, сбор метрик. Отсуствует дашборд
3. Логи - отсутствуют
4. Сеть - настроены security groups, на веб-серверах и elasticsearch отсутствуют внешние ip, настроен ssh bastion


![image](https://github.com/Maxterx10/Netology_diplom/assets/123242544/af7aa2ea-41a2-4999-8d03-271819ef40df)
![image](https://github.com/Maxterx10/Netology_diplom/assets/123242544/d9f38e70-0e2d-491c-baa9-241ed9e363e5)


