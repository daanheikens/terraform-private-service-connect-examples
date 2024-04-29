## PSC Service Attachment ##
resource "google_compute_service_attachment" "apache_web_server" {
  name                  = "apache-web-server"
  region                = var.region
  connection_preference = "ACCEPT_MANUAL"
  reconcile_connections = true
  enable_proxy_protocol = false
  target_service        = google_compute_forwarding_rule.apache_web_server_ilb.id
  nat_subnets           = [
    google_compute_subnetwork.web_app_nat.id
  ]

  dynamic "consumer_accept_lists" {
    for_each = var.accepted_consumers
    content {
      connection_limit  = consumer_accept_lists.value.connection_limit
      project_id_or_num = consumer_accept_lists.value.project_number
    }
  }
}

## IP address ##
resource "google_compute_address" "apache_web_server_ilb" {
  name         = "apache-web-server-ilb"
  region       = var.region
  subnetwork   = google_compute_subnetwork.web_app_ilb.id
  address_type = "INTERNAL"
}

## L4 Passthrough Load Balancer ##
resource "google_compute_forwarding_rule" "apache_web_server_ilb" {
  name                  = "apache-web-server-ilb"
  region                = var.region
  subnetwork            = google_compute_subnetwork.web_app_ilb.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  ports                 = [80]
  backend_service       = google_compute_region_backend_service.apache_web_server.id
}

# Backend service #
resource "google_compute_region_backend_service" "apache_web_server" {
  name                  = "apache-web-server"
  region                = var.region
  protocol              = "TCP"
  health_checks         = [
    google_compute_region_health_check.http.id
  ]

  backend {
    group          = google_compute_region_instance_group_manager.apache.instance_group
    balancing_mode = "CONNECTION"
  }
}

# Health check #
resource "google_compute_region_health_check" "http" {
  name   = "http"
  region = var.region

  http_health_check {
    port = "80"
  }
}
