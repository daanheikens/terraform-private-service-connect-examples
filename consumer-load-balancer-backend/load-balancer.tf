## IP address ##
resource "google_compute_address" "consumer_apache_web_server_ilb" {
  name         = "consumer-apache-web-server-ilb"
  region       = var.region
  subnetwork   = google_compute_subnetwork.consumer_load_balancer.id
  address_type = "INTERNAL"
}

## Internal L4 Proxy Load Balancer (This may also be an application load balancer or EXTERNAL load balancer) ##
resource "google_compute_forwarding_rule" "consumer_apache_web_server_ilb" {
  name                  = "consumer-apache-web-server-ilb"
  region                = var.region
  subnetwork            = google_compute_subnetwork.consumer_load_balancer.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_tcp_proxy.consumer_apache_web_server.id

  depends_on = [
    google_compute_subnetwork.proxy_only
  ]
}

resource "google_compute_region_target_tcp_proxy" "consumer_apache_web_server" {
  backend_service = google_compute_region_backend_service.consumer_apache_web_server.id
  name            = "consumer-apache-web-server"
  region          = var.region
}

# Backend service targeting the PSC NEG #
resource "google_compute_region_backend_service" "consumer_apache_web_server" {
  name                  = "consumer-apache-web-server"
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "TCP"
  # No health checks due PSC

  backend {
    group          = google_compute_region_network_endpoint_group.apache_web_server.id
    balancing_mode = "" # Empty string explicitly Required for PSC
  }
}

# PSC Neg targeting the producer service
resource "google_compute_region_network_endpoint_group" "apache_web_server" {
  name                  = "apache-web-server"
  region                = var.region
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = var.service_attachment_id
  network               = google_compute_network.consumer_load_balancer.id
  subnetwork            = google_compute_subnetwork.consumer_load_balancer.id
}
