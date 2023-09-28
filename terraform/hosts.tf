#VM-*

resource "yandex_compute_instance" "vm" {
  for_each = toset( var.vm_list )

  name = each.key

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd83u9thmahrv9lgedrk"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = false
    security_group_ids = [ 
      yandex_vpc_security_group.ssh-sg.id, 
      yandex_vpc_security_group.egress-sg.id, 
      yandex_vpc_security_group.web-sg.id, 
      yandex_vpc_security_group.zabbix-sg.id 
    ]
  }
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#Zabbix server

resource "yandex_compute_instance" "zabbix-server" {
  name = "zabbix-server"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd83u9thmahrv9lgedrk"
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-2.id
    security_group_ids = [ 
      yandex_vpc_security_group.ssh-sg.id, 
      yandex_vpc_security_group.egress-sg.id, 
      yandex_vpc_security_group.zabbix-server-sg.id 
    ]
    nat                = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#Elasticsearch

resource "yandex_compute_instance" "elasticsearch" {
  name = "elasticsearch"

  resources {
    cores  = 4
    memory = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd83u9thmahrv9lgedrk"
      size     = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false
    security_group_ids = [ 
      yandex_vpc_security_group.ssh-sg.id, 
      yandex_vpc_security_group.egress-sg.id, 
      yandex_vpc_security_group.zabbix-sg.id, 
      yandex_vpc_security_group.elastic-sg.id 
    ]
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#Kibana

resource "yandex_compute_instance" "kibana" {
  name = "kibana"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd83u9thmahrv9lgedrk"
      size = 8
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-2.id
    security_group_ids = [ 
      yandex_vpc_security_group.ssh-sg.id, 
      yandex_vpc_security_group.egress-sg.id, 
      yandex_vpc_security_group.zabbix-sg.id, 
      yandex_vpc_security_group.kibana-sg.id 
    ]
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#SSH bastion

resource "yandex_compute_instance" "bastion" {
  name = "bastion"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd83u9thmahrv9lgedrk"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-2.id
    nat                = true
    security_group_ids = [ 
      yandex_vpc_security_group.bastion-sg.id, 
      yandex_vpc_security_group.egress-sg.id, 
      yandex_vpc_security_group.zabbix-sg.id 
    ]
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}
