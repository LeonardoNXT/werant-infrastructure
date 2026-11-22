locals {
  development_account_id    = "904054820030"
  primary_availability_zone = sort(data.aws_availability_zones.available.names)[0]

  cidr_blocks = {
    public_subnet = "10.0.1.0/24"
    vpc           = "10.0.0.0/16"
  }

  ports = {
    auth_key_rotation_postgres_node = 30432
  }

  common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Network"
    ManagedBy   = "Terraform"
  }
}
