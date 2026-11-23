output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "vm_names" {
  value = [for inst in google_compute_instance.vm : inst.name]
}

output "db_instance_name" {
  value = google_sql_database_instance.db.name
}

output "dns_record_name" {
  value = google_dns_record_set.vm_record.name
}