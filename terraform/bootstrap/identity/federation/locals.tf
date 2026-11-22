locals {
  aws_accounts = {
    management  = "633697459676"
    development = "904054820030"
  }

  github = {
    owner_id        = "170183479"
    owner_name      = "LeonardoNXT"
    repository_id   = "1454700938"
    repository_name = "werant-infrastructure"
    workflow_refs = {
      compute   = "LeonardoNXT/werant-infrastructure/.github/workflows/terraform-compute.yml@refs/heads/main"
      messaging = "LeonardoNXT/werant-infrastructure/.github/workflows/terraform-messaging.yml@refs/heads/main"
      network   = "LeonardoNXT/werant-infrastructure/.github/workflows/terraform-network.yml@refs/heads/main"
      security  = "LeonardoNXT/werant-infrastructure/.github/workflows/terraform-security.yml@refs/heads/main"
      storage   = "LeonardoNXT/werant-infrastructure/.github/workflows/terraform-storage.yml@refs/heads/main"
    }
  }

  key_rotation_github = {
    owner_id        = "170183479"
    owner_name      = "LeonardoNXT"
    repository_id   = "1462086208"
    repository_name = "werant-key-rotation"
    workflow_ref    = "LeonardoNXT/werant-key-rotation/.github/workflows/deploy-lambda.yml@refs/heads/main"
  }

  development = {
    environment_name = "development"
  }
}
