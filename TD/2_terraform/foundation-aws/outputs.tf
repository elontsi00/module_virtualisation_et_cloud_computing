output "vpc_id" {
  value = aws_vpc.main.id
}

output "vm_names" {
  value = [for inst in aws_instance.vm : inst.tags["Name"]]
}

output "db_instance_id" {
  value = aws_db_instance.db.id
}

output "dns_fqdn" {
  value = aws_route53_record.vm_record.name
}