resource "google_compute_network" "consumer_load_balancer" {
  name                    = "consumer-load-balancer"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "consumer_load_balancer" {
  name                     = "consumer-load-balancer-${var.region}"
  ip_cidr_range            = "172.16.0.8/29"
  region                   = var.region
  network                  = google_compute_network.consumer_load_balancer.name
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "proxy_only" {
  name          = "proxy-only"
  region        = var.region
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.consumer_load_balancer.id
  ip_cidr_range = "10.0.0.0/23" # Recommended starting size: https://cloud.google.com/load-balancing/docs/proxy-only-subnets#proxy-subnet-size
}
