resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tmpl", {
    vm-1 = yandex_compute_instance.vm-1.network_interface.0.ip_address,
    vm-2 = yandex_compute_instance.vm-2.network_interface.0.ip_address,
    zabbix = yandex_compute_instance.zabbix-server.network_interface.0.ip_address,
    zabbix_nat = yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address,
    elastic = yandex_compute_instance.elasticsearch.network_interface.0.ip_address,
    kibana = yandex_compute_instance.kibana.network_interface.0.ip_address,
    bastion = yandex_compute_instance.bastion.network_interface.0.ip_address,
    bastion_nat = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    }
  )
  filename = "${path.module}/../ansible/hosts.ini"
}

resource "local_file" "web-conf" {
  content = templatefile("${path.module}/templates/web.tmpl", {
    alb_1 = yandex_alb_load_balancer.alb-1.listener.0.endpoint.0.address.0.external_ipv4_address.0.address
    }
  )
  filename = "${path.module}/../ansible/nginx/web.conf"
}

resource "local_file" "zabbix-nginx-conf" {
  content = templatefile("${path.module}/templates/nginx.conf.tmpl", {
    zabbix = yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address
    }
  )
  filename = "${path.module}/../ansible/roles/zabbix_server/templates/nginx.conf.j2"
}

resource "local_file" "zabbix-agent2-conf" {
  content = templatefile("${path.module}/templates/zabbix_agent2.conf.tmpl", {
    zabbix = yandex_compute_instance.zabbix-server.network_interface.0.ip_address
    }
  )
  filename = "${path.module}/../ansible/roles/zabbix_agent2/files/zabbix_agent2.conf"
}
