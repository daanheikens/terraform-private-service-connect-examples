# Just an example NAT gateway here to make the startup script of the VM's work.
resource "google_compute_router_nat" "example" {
  name                               = "example"
  router                             = google_compute_router.apache_web_server.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.web_app.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
