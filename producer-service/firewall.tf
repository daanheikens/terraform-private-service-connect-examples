# Allow health check ranges #
resource "google_compute_firewall" "allow_ingress_health_check_ranges" {
  name          = "allow-ingress-health-check-ranges"
  direction     = "INGRESS"
  network       = google_compute_network.apache_web_server.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20"]

  allow {
    protocol = "tcp"
  }

  target_tags = [
    "allow-health-checks"
  ]
}

# Allow traffic to the VMs from the NAT subnet #
resource "google_compute_firewall" "allow_ingress_http_psc_consumers" {
  name          = "allow-ingress-http-psc-consumers"
  direction     = "INGRESS"
  network       = google_compute_network.apache_web_server.id

  source_ranges = [
    google_compute_subnetwork.web_app_nat.ip_cidr_range
  ]

  target_service_accounts = [
    google_service_account.apache_web_server.email
  ]

  allow {
    protocol = "tcp"
    ports    = [80]
  }
}

