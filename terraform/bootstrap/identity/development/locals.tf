locals {

  aws_accounts = {
    management  = "633697459676"
    development = "904054820030"
  }

  templates = {
    github_oidc_role_name = "%s-github-oidc-role-dev"
  }

  environments = {
    dev = {
      life_cycles = {
        network   = {}
        compute   = {}
        security  = {}
        storage   = {}
        messaging = {}
      }
    }
  }

  policies = {
    network = {
      read = {
        sid    = "NetworkReadAccess"
        effect = "Allow"
        actions = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
        ]
        resources = [
          "*"
        ]
      }

      vpc = {
        sid    = "VpcManagement"
        effect = "Allow"
        actions = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute"
        ]
        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:vpc/*"
        ]
      }
      subnet = {
        sid    = "SubnetManagement"
        effect = "Allow"
        actions = [
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute"
        ]
        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:subnet/*",
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:vpc/*"
        ]
      }
      tagging = {
        sid    = "NetworkTagManagement"
        effect = "Allow"

        actions = [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]

        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:vpc/*",
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:subnet/*"
        ]
      }
    }
  }




  deployment_settings = {
    for life_cycle_name, _ in local.environments.dev.life_cycles :
    life_cycle_name => {
      github_oidc_role_name = format(
        local.templates.github_oidc_role_name,
        life_cycle_name
      )

      sid             = "Allow${title(life_cycle_name)}RoleAssumption"
      root_account_id = local.aws_accounts.management
      life_cycle_name = life_cycle_name
    }
  }



}
