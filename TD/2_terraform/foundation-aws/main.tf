# 1. VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "app-vpc"
  }
}

# Sous-réseaux dans le VPC (requis pour EC2 et RDS)
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "app-subnet-${count.index + 1}"
  }
}

# 2 & 5. Instances VM (EC2) dans le VPC + méta-argument count
resource "aws_instance" "vm" {
  count         = var.vm_count
  ami           = "ami-0c4e4b4eb2e11d1d4"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public[count.index % length(aws_subnet.public)].id

  tags = {
    Name = "app-vm-${count.index + 1}"
  }
}

# 3. Base de données rattachée au même VPC via un subnet group
resource "aws_db_subnet_group" "main" {
  name       = "app-db-subnet-group"
  subnet_ids = [for s in aws_subnet.public : s.id]

  tags = {
    Name = "app-db-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  identifier           = "app-db-instance"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "appuser"
  password             = "ChangeMeInProd123!"
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true

  tags = {
    Name = "app-db-instance"
  }
}

# 4. Zone et enregistrement DNS Route 53
resource "aws_route53_zone" "zone" {
  name = var.dns_domain
}

resource "aws_route53_record" "vm_record" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "app.${var.dns_domain}"
  type    = "A"
  ttl     = 300
  records = [for inst in aws_instance.vm : inst.public_ip]
}