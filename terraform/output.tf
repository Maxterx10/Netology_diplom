#Output

output "ext_ip_address_alb" {
  value = yandex_alb_load_balancer.alb-1.listener.0.endpoint.0.address.0.external_ipv4_address.0.address
}
output "ip_list" {
  value = setunion([
    for vm_name in var.vm_list :  
      "int_ip ${vm_name}:          ${yandex_compute_instance.vm[vm_name].network_interface.0.ip_address}"
    ], [
    "int_ip zabbix-server: ${yandex_compute_instance.zabbix-server.network_interface.0.ip_address}",
    "int_ip elasticsearch: ${yandex_compute_instance.elasticsearch.network_interface.0.ip_address}",
    "int_ip kibana:        ${yandex_compute_instance.kibana.network_interface.0.ip_address}",
    "int_ip bastion:       ${yandex_compute_instance.bastion.network_interface.0.ip_address}"
    ], [
    for vm_name in var.vm_list :
      "ext_ip ${vm_name}:          ${yandex_compute_instance.vm[vm_name].network_interface.0.nat_ip_address}"
    ], [
    "ext_ip zabbix-server: ${yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address}",
    "ext_ip elasticsearch: ${yandex_compute_instance.elasticsearch.network_interface.0.nat_ip_address}",
    "ext_ip kibana:        ${yandex_compute_instance.kibana.network_interface.0.nat_ip_address}",
    "ext_ip bastion:       ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"
    ]
  )
}
output "ssh_command" {
  value = "ssh -J user@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} user@"
}
