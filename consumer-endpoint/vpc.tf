resource "google_compute_network" "consumer_endpoint" {
  name                    = "consumer-endpoint"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "consumer_endpoint" {
  name                     = "consumer-endpoint-${var.region}"
  ip_cidr_range            = "172.16.0.0/29"
  region                   = var.region
  network                  = google_compute_network.consumer_endpoint.name
  private_ip_google_access = true
}
