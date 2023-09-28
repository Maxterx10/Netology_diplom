#Target group

resource "yandex_alb_target_group" "tg-1" {
  name           = "tg-1"

  dynamic "target" {
    for_each = toset( var.vm_list )
    content {
      subnet_id    = yandex_vpc_subnet.subnet-1.id
      ip_address   = yandex_compute_instance.vm[target.key].network_interface.0.ip_address
    }
  }
}

#Backend group

resource "yandex_alb_backend_group" "bg-1" {
  name                     = "bg-1"
  session_affinity {
    connection {
      source_ip = true
    }
  }

  http_backend {
    name                   = "backend-1"
    weight                 = 1
    port                   = 80
    target_group_ids       = [ yandex_alb_target_group.tg-1.id ]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

#HTTP-router

resource "yandex_alb_http_router" "router-1" {
  name          = "router-1"
}

resource "yandex_alb_virtual_host" "vh-1" {
  name                    = "vh-1"
  http_router_id          = yandex_alb_http_router.router-1.id
  route {
    name                  = "route-1"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.bg-1.id
        timeout           = "60s"
      }
    }
  }
}  

#ALB

resource "yandex_alb_load_balancer" "alb-1" {
  name        = "alb-1"
  network_id  = yandex_vpc_network.network-1.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet-2.id 
    }
  }

  listener {
    name = "listener-1"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.router-1.id
      }
    }
  }
    security_group_ids = [ yandex_vpc_security_group.alb-sg.id, yandex_vpc_security_group.egress-sg.id ]
}
