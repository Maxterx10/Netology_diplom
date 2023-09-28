#Application load balancer security grop

resource "yandex_vpc_security_group" "alb-sg" {
  name        = "alb-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol          = "TCP"
    predefined_target = "loadbalancer_healthchecks"
    port              = 30080  
  }
}

#ALB to Web-servers security group

resource "yandex_vpc_security_group" "web-sg" {
  name        = "web-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "TCP"
    security_group_id = yandex_vpc_security_group.alb-sg.id
    port           = 80
  }
}

#SSH Bastion security group

resource "yandex_vpc_security_group" "bastion-sg" {
  name        = "bastion-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks    = [ "0.0.0.0/0" ]
    port              = 22
  }

  egress {
    protocol          = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 22
  }
}

#SSH security group

resource "yandex_vpc_security_group" "ssh-sg" {
  name        = "ssh-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.bastion-sg.id
    port              = 22
  }

  egress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.bastion-sg.id
    port = 22
  }
}

#Zabbix agent security group

resource "yandex_vpc_security_group" "zabbix-sg" {
  name        = "zabbix-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.zabbix-server-sg.id
    from_port = 10050
    to_port = 10051
  }

  egress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.zabbix-server-sg.id
    from_port = 10050
    to_port = 10051
  }
}

#Zabbix server secutity group

resource "yandex_vpc_security_group" "zabbix-server-sg" {
  name        = "zabbix-server-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 80
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.subnet-2.v4_cidr_blocks
    from_port = 10050
    to_port = 10052
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.subnet-1.v4_cidr_blocks
    from_port = 10050
    to_port = 10051
  }

}

#Elasticsearch server security group

resource "yandex_vpc_security_group" "elastic-sg" {
  name        = "elastic-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.subnet-1.v4_cidr_blocks                                            
    port = 9200
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.subnet-2.v4_cidr_blocks
    port = 9200
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.subnet-1.v4_cidr_blocks
    port = 9300
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.subnet-2.v4_cidr_blocks                                            
    port = 9300
  }

}

#Kibana server security group

resource "yandex_vpc_security_group" "kibana-sg" {
  name        = "kibana-sg"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 5601
  }

}

#Full egress traffic allowed

resource "yandex_vpc_security_group" "egress-sg" {
  name        = "egress-sg"
  network_id  = yandex_vpc_network.network-1.id

  egress {
    protocol          = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 65535
  }
}

