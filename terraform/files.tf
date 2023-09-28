resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tmpl", {
    vm = "%{ for vm_name in var.vm_list }${vm_name} ansible_host=${yandex_compute_instance.vm[vm_name].network_interface.0.ip_address }\n%{ endfor }",
    zabbix = yandex_compute_instance.zabbix-server.network_interface.0.ip_address,
    zabbix_nat = yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address,
    elastic = yandex_compute_instance.elasticsearch.network_interface.0.ip_address,
    kibana = yandex_compute_instance.kibana.network_interface.0.ip_address,
    bastion = yandex_compute_instance.bastion.network_interface.0.ip_address,
    bastion_nat = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
    alb = yandex_alb_load_balancer.alb-1.listener.0.endpoint.0.address.0.external_ipv4_address.0.address
    }
  )
  filename = "${path.module}/../ansible/hosts.ini"
}

