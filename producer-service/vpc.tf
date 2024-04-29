resource "google_compute_network" "apache_web_server" {
  name                    = "apache-web-server"
  auto_create_subnetworks = false
}

resource "google_compute_router" "apache_web_server" {
  name    = "apache-web-server"
  network = google_compute_network.apache_web_server.id
  region  = var.region
}

## Subnet used for the web application ##
resource "google_compute_subnetwork" "web_app" {
  name                     = "web-app-${var.region}"
  ip_cidr_range            = "10.0.0.0/29"
  region                   = var.region
  network                  = google_compute_network.apache_web_server.name
  private_ip_google_access = true
}

## Subnet used for the load balancer frontend ##
resource "google_compute_subnetwork" "web_app_ilb" {
  name                     = "web-app-ilb-${var.region}"
  ip_cidr_range            = "10.0.0.8/29"
  region                   = var.region
  network                  = google_compute_network.apache_web_server.name
  private_ip_google_access = true
}

## Private Service Connect NAT subnet ##
resource "google_compute_subnetwork" "web_app_nat" {
  name                     = "web-app-nat-${var.region}"
  ip_cidr_range            = "192.16.0.0/24" # Allows up to 252 consumers to be connected
  region                   = var.region
  network                  = google_compute_network.apache_web_server.name
  private_ip_google_access = true
  purpose                  = "PRIVATE_SERVICE_CONNECT"
}