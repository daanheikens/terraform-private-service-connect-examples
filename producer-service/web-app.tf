## Example VM using a apache web server. This may also be a Cloud Run or GKE application. ##
data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

data "template_file" "apache_startup" {
  template = file("apache-startup.sh")
}

resource "google_service_account" "apache_web_server" {
  account_id = "apache-web-server"
}

## VM Instance ##
resource "google_compute_instance_template" "apache_web_server" {
  name         = "apache-web-server"
  machine_type = "e2-standard-2"
  tags = [
    "allow-health-checks"
  ]

  disk {
    source_image = data.google_compute_image.debian.name
    disk_size_gb = 100
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.web_app.id
  }

  service_account {
    email = google_service_account.apache_web_server.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = data.template_file.apache_startup.rendered
}

## Instance Group ##
resource "google_compute_region_instance_group_manager" "apache" {
  name               = "apache-web-server-mig"
  base_instance_name = "apache"
  region             = var.region
  target_size        = "1"

  version {
    instance_template = google_compute_instance_template.apache_web_server.id
  }
}
