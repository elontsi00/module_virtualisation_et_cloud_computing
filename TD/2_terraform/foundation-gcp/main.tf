# Point 1 : VPC
resource "google_compute_network" "vpc" {
  name                    = "app-vpc"
  auto_create_subnetworks = true
}

# Points 2 et 5 : Instance Compute Engine dans le VPC + méta-argument count
resource "google_compute_instance" "vm" {
  count        = var.vm_count
  name         = "app-vm-${count.index + 1}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.vpc.name
    access_config {}
  }

  depends_on = [google_compute_network.vpc]
}

# Point 3 : Base de données dans le même VPC
resource "google_sql_database_instance" "db" {
  name             = "app-db-instance"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }

  depends_on = [google_compute_network.vpc]
}

# Point 4 : Zone DNS + entrée DNS (google_dns_record_set)
resource "google_dns_managed_zone" "zone" {
  name     = "app-zone"
  dns_name = var.dns_domain
}

resource "google_dns_record_set" "vm_record" {
  name         = "app.${google_dns_managed_zone.zone.dns_name}"
  managed_zone = google_dns_managed_zone.zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [
    for inst in google_compute_instance.vm :
    inst.network_interface[0].access_config[0].nat_ip
  ]
}