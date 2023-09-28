resource "yandex_compute_snapshot_schedule" "snap-1" {
  name           = "snap-1"

  schedule_policy {
	expression = "43 18 * * *"
  }

  retention_period = "168h"#



  disk_ids = setunion([
    for vm_name in var.vm_list : 
      yandex_compute_instance.vm[vm_name].boot_disk.0.disk_id
    ], [
      yandex_compute_instance.zabbix-server.boot_disk.0.disk_id,
      yandex_compute_instance.elasticsearch.boot_disk.0.disk_id,
      yandex_compute_instance.kibana.boot_disk.0.disk_id,
      yandex_compute_instance.bastion.boot_disk.0.disk_id
    ]
  )
}
