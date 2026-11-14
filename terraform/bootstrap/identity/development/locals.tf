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

    compute = {
      read = {
        sid    = "ComputeReadDiscovery"
        effect = "Allow"
        actions = [
          "ec2:Describe*",
          "lambda:Get*",
          "lambda:List*"
        ]
        resources = [
          "*"
        ]
      }

      run_amazon_ami = {
        sid     = "RunInstancesWithAmazonOwnedAmi"
        effect  = "Allow"
        actions = ["ec2:RunInstances"]
        resources = [
          "arn:aws:ec2:sa-east-1::image/ami-*"
        ]
        conditions = [
          {
            test     = "StringEquals"
            variable = "ec2:Owner"
            values   = ["amazon"]
          }
        ]
      }

      use_network_for_launch = {
        sid     = "UseNetworkResourcesForInstanceLaunch"
        effect  = "Allow"
        actions = ["ec2:RunInstances"]
        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:subnet/*",
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:security-group/*",
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:network-interface/*"
        ]
      }

      create_tagged_resources = {
        sid     = "CreateTaggedComputeResources"
        effect  = "Allow"
        actions = ["ec2:RunInstances"]
        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:instance/*",
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:volume/*"
        ]
        conditions = [
          {
            test     = "StringEquals"
            variable = "aws:RequestTag/Project"
            values   = ["Werant"]
          },
          {
            test     = "StringEquals"
            variable = "aws:RequestTag/Environment"
            values   = ["Development"]
          },
          {
            test     = "StringEquals"
            variable = "aws:RequestTag/Lifecycle"
            values   = ["Compute"]
          },
          {
            test     = "StringEquals"
            variable = "aws:RequestTag/ManagedBy"
            values   = ["Terraform"]
          }
        ]
      }

      tag_resources_during_launch = {
        sid     = "TagComputeResourcesDuringLaunch"
        effect  = "Allow"
        actions = ["ec2:CreateTags"]
        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:instance/*",
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:volume/*"
        ]
        conditions = [
          {
            test     = "StringEquals"
            variable = "ec2:CreateAction"
            values   = ["RunInstances"]
          }
        ]
      }

      instance_lifecycle = {
        sid    = "ManageEc2InstanceLifecycle"
        effect = "Allow"
        actions = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:TerminateInstances",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyInstanceMetadataOptions"
        ]
        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:instance/*"
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
