data "aws_vpc" "development" {
  tags = {
    Name        = "werant-dev-vpc"
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Network"
    ManagedBy   = "Terraform"
    Tier        = "Foundation"
    Workload    = "CoreNetwork"
  }
}

data "aws_subnet" "public" {
  vpc_id = data.aws_vpc.development.id

  tags = {
    Name        = "werant-dev-public-1"
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Network"
    ManagedBy   = "Terraform"
    Tier        = "Public"
    Workload    = "ApplicationIngress"
  }
}

data "aws_security_group" "application" {
  name   = "werant-dev-application"
  vpc_id = data.aws_vpc.development.id

  tags = {
    Name        = "werant-dev-application"
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Network"
    ManagedBy   = "Terraform"
    Tier        = "Public"
    Workload    = "ApplicationIngress"
  }
}

data "aws_iam_instance_profile" "application" {
  name = "werant-application-ec2-profile-dev"
}
