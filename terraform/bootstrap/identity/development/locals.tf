locals {

  aws_accounts = {
    management  = "633697459676"
    development = "904054820030"
  }

  runtime_resources = {
    auth_key_rotation_lambda = {
      function_name  = "werant-auth-key-rotation-dev"
      log_group_name = "/aws/lambda/werant-auth-key-rotation-dev"
      alias_name     = "live"
    }

    auth_key_rotation_scheduler = {
      role_name           = "werant-auth-key-rotation-scheduler-role-dev"
      schedule_group_name = "werant-auth-key-rotation-dev"
    }

    ec2_scheduler = {
      role_name           = "werant-ec2-scheduler-role-dev"
      schedule_group_name = "werant-compute-operations-dev"
    }
  }

  auth_key_rotation_code_deployment = {
    github_oidc_role_name = "auth-key-rotation-github-oidc-role-dev"
    role_name             = "auth-key-rotation-code-deploy-role-dev"
    policy_name           = "auth-key-rotation-code-deploy-policy-dev"
  }

  auth_key_rotation_function_arn           = "arn:aws:lambda:sa-east-1:${local.aws_accounts.development}:function:${local.runtime_resources.auth_key_rotation_lambda.function_name}"
  auth_key_rotation_postgres_parameter_arn = "arn:aws:ssm:sa-east-1:${local.aws_accounts.development}:parameter/werant/development/auth/postgres"

  auth_key_rotation_code_deployment_statements = {
    read_function_deployment = {
      sid    = "ReadAuthKeyRotationFunctionDeployment"
      effect = "Allow"
      actions = [
        "lambda:GetFunctionConfiguration"
      ]
      resources = [local.auth_key_rotation_function_arn]
    }

    publish_function_code = {
      sid    = "PublishAuthKeyRotationFunctionCode"
      effect = "Allow"
      actions = [
        "lambda:PublishVersion",
        "lambda:UpdateFunctionCode"
      ]
      resources = [local.auth_key_rotation_function_arn]
    }

    promote_live_alias = {
      sid    = "PromoteAuthKeyRotationLiveAlias"
      effect = "Allow"
      actions = [
        "lambda:GetAlias",
        "lambda:UpdateAlias"
      ]
      resources = [local.auth_key_rotation_alias_arn]
    }
  }

  compute_scheduler_common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Compute"
    ManagedBy   = "Terraform"
  }

  compute_scheduler_group_arn = "arn:aws:scheduler:sa-east-1:${local.aws_accounts.development}:schedule-group/${local.runtime_resources.ec2_scheduler.schedule_group_name}"
  compute_scheduler_arn       = "arn:aws:scheduler:sa-east-1:${local.aws_accounts.development}:schedule/${local.runtime_resources.ec2_scheduler.schedule_group_name}/*"

  compute_scheduler_request_tag_conditions = [
    for key, value in local.compute_scheduler_common_tags : {
      test     = "StringEquals"
      variable = "aws:RequestTag/${key}"
      values   = [value]
    }
  ]

  compute_scheduler_resource_tag_conditions = [
    for key, value in local.compute_scheduler_common_tags : {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${key}"
      values   = [value]
    }
  ]

  messaging_scheduler_common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Messaging"
    ManagedBy   = "Terraform"
  }

  messaging_scheduler_group_arn = "arn:aws:scheduler:sa-east-1:${local.aws_accounts.development}:schedule-group/${local.runtime_resources.auth_key_rotation_scheduler.schedule_group_name}"
  messaging_scheduler_arn       = "arn:aws:scheduler:sa-east-1:${local.aws_accounts.development}:schedule/${local.runtime_resources.auth_key_rotation_scheduler.schedule_group_name}/*"
  auth_key_rotation_alias_arn   = "${local.auth_key_rotation_function_arn}:${local.runtime_resources.auth_key_rotation_lambda.alias_name}"

  messaging_scheduler_request_tag_conditions = [
    for key, value in local.messaging_scheduler_common_tags : {
      test     = "StringEquals"
      variable = "aws:RequestTag/${key}"
      values   = [value]
    }
  ]

  messaging_scheduler_resource_tag_conditions = [
    for key, value in local.messaging_scheduler_common_tags : {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${key}"
      values   = [value]
    }
  ]

  security_kms_common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Security"
    ManagedBy   = "Terraform"
  }

  security_kms_workloads = [
    "ApplicationStorage",
    "AuthEnvelopeEncryption"
  ]

  security_resources = {
    auth_envelope_kms = {
      alias_name = "alias/werant-auth-envelope-encryption-dev"
      alias_arn  = "arn:aws:kms:sa-east-1:${local.aws_accounts.development}:alias/werant-auth-envelope-encryption-dev"
      tags = merge(local.security_kms_common_tags, {
        Workload = "AuthEnvelopeEncryption"
      })
    }

    application_storage_kms = {
      alias_name = "alias/werant-storage-dev"
      alias_arn  = "arn:aws:kms:sa-east-1:${local.aws_accounts.development}:alias/werant-storage-dev"
      tags = merge(local.security_kms_common_tags, {
        Workload = "ApplicationStorage"
      })
    }
  }

  security_kms_key_arn = "arn:aws:kms:sa-east-1:${local.aws_accounts.development}:key/*"

  network_common_tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Network"
    ManagedBy   = "Terraform"
  }

  network_request_tag_conditions = [
    for key, value in local.network_common_tags : {
      test     = "StringEquals"
      variable = "aws:RequestTag/${key}"
      values   = [value]
    }
  ]

  network_resource_tag_conditions = [
    for key, value in local.network_common_tags : {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${key}"
      values   = [value]
    }
  ]

  network_resource_arns = {
    egress_only_internet_gateway = "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:egress-only-internet-gateway/*"
    internet_gateway             = "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:internet-gateway/*"
    route_table                  = "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:route-table/*"
    security_group               = "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:security-group/*"
    security_group_rule          = "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:security-group-rule/*"
    subnet                       = "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:subnet/*"
    vpc                          = "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:vpc/*"
  }

  storage_resources = {
    application_buckets = {
      arn = "arn:aws:s3:::werant-dev-*"
    }

    application_storage_kms = {
      alias_name = local.security_resources.application_storage_kms.alias_name
      key_arn    = local.security_kms_key_arn
    }
  }

  storage_bucket_conditions = [
    {
      test     = "StringEquals"
      variable = "s3:ResourceAccount"
      values   = [local.aws_accounts.development]
    }
  ]

  security_kms_request_tag_conditions = concat([
    for key, value in local.security_kms_common_tags : {
      test     = "StringEquals"
      variable = "aws:RequestTag/${key}"
      values   = [value]
    }
    ], [
    {
      test     = "StringEquals"
      variable = "aws:RequestTag/Workload"
      values   = local.security_kms_workloads
    }
  ])

  security_kms_resource_tag_conditions = [
    {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = [local.security_kms_common_tags.Project]
    },
    {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Workload"
      values   = local.security_kms_workloads
    }
  ]

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
        sid    = "DiscoverNetworkResources"
        effect = "Allow"
        actions = [
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeEgressOnlyInternetGateways",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeVpcs"
        ]
        resources = ["*"]
        conditions = [
          {
            test     = "StringEquals"
            variable = "aws:RequestedRegion"
            values   = ["sa-east-1"]
          }
        ]
      }

      create_tagged_vpc = {
        sid       = "CreateTaggedVpc"
        effect    = "Allow"
        actions   = ["ec2:CreateVpc"]
        resources = [local.network_resource_arns.vpc]
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "StringEquals"
            variable = "ec2:Region"
            values   = ["sa-east-1"]
          },
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      create_tagged_subnet = {
        sid       = "CreateTaggedSubnet"
        effect    = "Allow"
        actions   = ["ec2:CreateSubnet"]
        resources = [local.network_resource_arns.subnet]
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "StringEquals"
            variable = "ec2:Region"
            values   = ["sa-east-1"]
          },
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      use_network_vpc_for_subnet = {
        sid        = "UseNetworkVpcForSubnet"
        effect     = "Allow"
        actions    = ["ec2:CreateSubnet"]
        resources  = [local.network_resource_arns.vpc]
        conditions = local.network_resource_tag_conditions
      }

      create_tagged_internet_gateway = {
        sid       = "CreateTaggedInternetGateway"
        effect    = "Allow"
        actions   = ["ec2:CreateInternetGateway"]
        resources = [local.network_resource_arns.internet_gateway]
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "StringEquals"
            variable = "ec2:Region"
            values   = ["sa-east-1"]
          },
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      create_tagged_egress_only_internet_gateway = {
        sid       = "CreateTaggedEgressOnlyInternetGateway"
        effect    = "Allow"
        actions   = ["ec2:CreateEgressOnlyInternetGateway"]
        resources = [local.network_resource_arns.egress_only_internet_gateway]
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "StringEquals"
            variable = "ec2:Region"
            values   = ["sa-east-1"]
          },
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      use_network_vpc_for_egress_only_internet_gateway = {
        sid        = "UseNetworkVpcForEgressOnlyInternetGateway"
        effect     = "Allow"
        actions    = ["ec2:CreateEgressOnlyInternetGateway"]
        resources  = [local.network_resource_arns.vpc]
        conditions = local.network_resource_tag_conditions
      }

      create_tagged_route_table = {
        sid       = "CreateTaggedRouteTable"
        effect    = "Allow"
        actions   = ["ec2:CreateRouteTable"]
        resources = [local.network_resource_arns.route_table]
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "StringEquals"
            variable = "ec2:Region"
            values   = ["sa-east-1"]
          },
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      use_network_vpc_for_route_table = {
        sid        = "UseNetworkVpcForRouteTable"
        effect     = "Allow"
        actions    = ["ec2:CreateRouteTable"]
        resources  = [local.network_resource_arns.vpc]
        conditions = local.network_resource_tag_conditions
      }

      create_tagged_security_group = {
        sid       = "CreateTaggedSecurityGroup"
        effect    = "Allow"
        actions   = ["ec2:CreateSecurityGroup"]
        resources = [local.network_resource_arns.security_group]
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "StringEquals"
            variable = "ec2:Region"
            values   = ["sa-east-1"]
          },
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      use_network_vpc_for_security_group = {
        sid        = "UseNetworkVpcForSecurityGroup"
        effect     = "Allow"
        actions    = ["ec2:CreateSecurityGroup"]
        resources  = [local.network_resource_arns.vpc]
        conditions = local.network_resource_tag_conditions
      }

      create_tagged_security_group_rules = {
        sid    = "CreateTaggedSecurityGroupRules"
        effect = "Allow"
        actions = [
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress"
        ]
        resources = [local.network_resource_arns.security_group_rule]
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      tag_network_resources_during_creation = {
        sid       = "TagNetworkResourcesDuringCreation"
        effect    = "Allow"
        actions   = ["ec2:CreateTags"]
        resources = values(local.network_resource_arns)
        conditions = concat(local.network_request_tag_conditions, [
          {
            test     = "StringEquals"
            variable = "ec2:CreateAction"
            values   = ["CreateEgressOnlyInternetGateway", "CreateInternetGateway", "CreateRouteTable", "CreateSecurityGroup", "CreateSubnet", "CreateVpc"]
          },
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.network_common_tags), ["Name", "Tier", "Workload"])
          }
        ])
      }

      manage_network_resource_lifecycle = {
        sid    = "ManageNetworkResourceLifecycle"
        effect = "Allow"
        actions = [
          "ec2:AssociateSubnetCidrBlock",
          "ec2:AssociateVpcCidrBlock",
          "ec2:DeleteSubnet",
          "ec2:DeleteVpc",
          "ec2:DisassociateSubnetCidrBlock",
          "ec2:DisassociateVpcCidrBlock",
          "ec2:ModifySubnetAttribute",
          "ec2:ModifyVpcAttribute"
        ]
        resources = [
          local.network_resource_arns.subnet,
          local.network_resource_arns.vpc
        ]
        conditions = local.network_resource_tag_conditions
      }

      attach_network_internet_gateway = {
        sid    = "AttachNetworkInternetGateway"
        effect = "Allow"
        actions = [
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway"
        ]
        resources = [
          local.network_resource_arns.internet_gateway,
          local.network_resource_arns.vpc
        ]
        conditions = local.network_resource_tag_conditions
      }

      manage_network_routing_resources = {
        sid    = "ManageNetworkRoutingResources"
        effect = "Allow"
        actions = [
          "ec2:DeleteEgressOnlyInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteRouteTable"
        ]
        resources = [
          local.network_resource_arns.egress_only_internet_gateway,
          local.network_resource_arns.internet_gateway,
          local.network_resource_arns.route_table
        ]
        conditions = local.network_resource_tag_conditions
      }

      manage_network_routes = {
        sid    = "ManageNetworkRoutes"
        effect = "Allow"
        actions = [
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:ReplaceRoute"
        ]
        resources  = [local.network_resource_arns.route_table]
        conditions = local.network_resource_tag_conditions
      }

      associate_network_route_table = {
        sid    = "AssociateNetworkRouteTable"
        effect = "Allow"
        actions = [
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:ReplaceRouteTableAssociation"
        ]
        resources = [
          local.network_resource_arns.route_table,
          local.network_resource_arns.subnet
        ]
        conditions = local.network_resource_tag_conditions
      }

      manage_network_security_group = {
        sid        = "ManageNetworkSecurityGroup"
        effect     = "Allow"
        actions    = ["ec2:DeleteSecurityGroup"]
        resources  = [local.network_resource_arns.security_group]
        conditions = local.network_resource_tag_conditions
      }

      manage_network_security_group_rules = {
        sid    = "ManageNetworkSecurityGroupRules"
        effect = "Allow"
        actions = [
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:ModifySecurityGroupRules",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
          "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
        ]
        resources = [
          local.network_resource_arns.security_group,
          local.network_resource_arns.security_group_rule
        ]
        conditions = local.network_resource_tag_conditions
      }

      manage_network_resource_tags = {
        sid    = "ManageNetworkResourceTags"
        effect = "Allow"
        actions = [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]
        resources = values(local.network_resource_arns)
        conditions = concat(local.network_resource_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = ["Name", "Tier", "Workload"]
          }
        ])
      }
    }

    compute = {
      read = {
        sid    = "ComputeReadDiscovery"
        effect = "Allow"
        actions = [
          "ec2:Describe*",
          "ec2:GetSecurityGroupsForVpc",
          "lambda:Get*",
          "lambda:List*"
        ]
        resources = [
          "*"
        ]
      }

      read_application_instance_profile = {
        sid       = "ReadApplicationInstanceProfile"
        effect    = "Allow"
        actions   = ["iam:GetInstanceProfile"]
        resources = [aws_iam_instance_profile.application.arn]
      }

      read_auth_key_rotation_lambda_role = {
        sid       = "ReadAuthKeyRotationLambdaRole"
        effect    = "Allow"
        actions   = ["iam:GetRole"]
        resources = [module.auth_key_rotation_lambda_role.aws_iam_role_arn]
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

      manage_resource_tags = {
        sid    = "ManageEc2ResourceTags"
        effect = "Allow"
        actions = [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]
        resources = [
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:instance/*",
          "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:volume/*"
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

      create_tagged_lambda_functions = {
        sid     = "CreateTaggedLambdaFunctions"
        effect  = "Allow"
        actions = ["lambda:CreateFunction"]
        resources = [
          "arn:aws:lambda:sa-east-1:${local.aws_accounts.development}:function:*"
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

      lambda_function_lifecycle = {
        sid    = "ManageLambdaFunctionLifecycle"
        effect = "Allow"
        actions = [
          "lambda:DeleteFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:PublishVersion"
        ]
        resources = [
          "arn:aws:lambda:sa-east-1:${local.aws_accounts.development}:function:*"
        ]
      }

      lambda_alias_lifecycle = {
        sid    = "ManageLambdaAliases"
        effect = "Allow"
        actions = [
          "lambda:CreateAlias",
          "lambda:UpdateAlias",
          "lambda:DeleteAlias"
        ]
        resources = [
          "arn:aws:lambda:sa-east-1:${local.aws_accounts.development}:function:*"
        ]
      }

      lambda_reserved_concurrency = {
        sid    = "ManageLambdaReservedConcurrency"
        effect = "Allow"
        actions = [
          "lambda:PutFunctionConcurrency",
          "lambda:DeleteFunctionConcurrency"
        ]
        resources = [
          "arn:aws:lambda:sa-east-1:${local.aws_accounts.development}:function:*"
        ]
      }

      lambda_tags = {
        sid    = "ManageLambdaFunctionTags"
        effect = "Allow"
        actions = [
          "lambda:TagResource",
          "lambda:UntagResource"
        ]
        resources = [
          "arn:aws:lambda:sa-east-1:${local.aws_accounts.development}:function:*"
        ]
      }

      cloudwatch_logs_read = {
        sid       = "DiscoverCloudWatchLogGroups"
        effect    = "Allow"
        actions   = ["logs:DescribeLogGroups"]
        resources = ["*"]
      }

      create_auth_key_rotation_log_group = {
        sid     = "CreateAuthKeyRotationLogGroup"
        effect  = "Allow"
        actions = ["logs:CreateLogGroup"]
        resources = [
          "arn:aws:logs:sa-east-1:${local.aws_accounts.development}:log-group:${local.runtime_resources.auth_key_rotation_lambda.log_group_name}"
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
          },
          {
            test     = "StringEquals"
            variable = "aws:RequestTag/Workload"
            values   = ["AuthKeyRotation"]
          }
        ]
      }

      auth_key_rotation_log_group_lifecycle = {
        sid    = "ManageAuthKeyRotationLogGroup"
        effect = "Allow"
        actions = [
          "logs:DeleteLogGroup",
          "logs:ListTagsForResource",
          "logs:PutRetentionPolicy"
        ]
        resources = [
          "arn:aws:logs:sa-east-1:${local.aws_accounts.development}:log-group:${local.runtime_resources.auth_key_rotation_lambda.log_group_name}"
        ]
      }

      auth_key_rotation_log_group_tags = {
        sid    = "ManageAuthKeyRotationLogGroupTags"
        effect = "Allow"
        actions = [
          "logs:TagResource",
          "logs:UntagResource"
        ]
        resources = [
          "arn:aws:logs:sa-east-1:${local.aws_accounts.development}:log-group:${local.runtime_resources.auth_key_rotation_lambda.log_group_name}"
        ]
        conditions = [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values = [
              "Project",
              "Environment",
              "Lifecycle",
              "ManagedBy",
              "Workload"
            ]
          }
        ]
      }

      pass_auth_key_rotation_lambda_role = {
        sid     = "PassAuthKeyRotationLambdaRole"
        effect  = "Allow"
        actions = ["iam:PassRole"]
        resources = [
          module.auth_key_rotation_lambda_role.aws_iam_role_arn
        ]
        conditions = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["lambda.amazonaws.com"]
          }
        ]
      }

      pass_application_ec2_role = {
        sid     = "PassApplicationEc2Role"
        effect  = "Allow"
        actions = ["iam:PassRole"]
        resources = [
          module.application_ec2_role.aws_iam_role_arn
        ]
        conditions = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["ec2.amazonaws.com"]
          }
        ]
      }
    }

    compute_scheduler = {
      read_execution_role = {
        sid       = "ReadEc2SchedulerExecutionRole"
        effect    = "Allow"
        actions   = ["iam:GetRole"]
        resources = [module.ec2_scheduler_role.aws_iam_role_arn]
      }

      list = {
        sid    = "DiscoverComputeSchedules"
        effect = "Allow"
        actions = [
          "scheduler:ListScheduleGroups",
          "scheduler:ListSchedules"
        ]
        resources = ["*"]
      }

      create_tagged_group = {
        sid    = "CreateTaggedComputeScheduleGroup"
        effect = "Allow"
        actions = [
          "scheduler:CreateScheduleGroup",
          "scheduler:TagResource"
        ]
        resources = [local.compute_scheduler_group_arn]
        conditions = concat(local.compute_scheduler_request_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.compute_scheduler_common_tags), ["Workload"])
          }
        ])
      }

      read_and_delete_group = {
        sid    = "ManageComputeScheduleGroup"
        effect = "Allow"
        actions = [
          "scheduler:DeleteScheduleGroup",
          "scheduler:GetScheduleGroup",
          "scheduler:ListTagsForResource"
        ]
        resources  = [local.compute_scheduler_group_arn]
        conditions = local.compute_scheduler_resource_tag_conditions
      }

      manage_group_tags = {
        sid    = "ManageComputeScheduleGroupTags"
        effect = "Allow"
        actions = [
          "scheduler:TagResource",
          "scheduler:UntagResource"
        ]
        resources = [local.compute_scheduler_group_arn]
        conditions = concat(local.compute_scheduler_resource_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.compute_scheduler_common_tags), ["Workload"])
          }
        ])
      }

      manage_schedules = {
        sid    = "ManageComputeSchedules"
        effect = "Allow"
        actions = [
          "scheduler:CreateSchedule",
          "scheduler:DeleteSchedule",
          "scheduler:GetSchedule",
          "scheduler:UpdateSchedule"
        ]
        resources = [local.compute_scheduler_arn]
      }

      pass_execution_role = {
        sid       = "PassEc2SchedulerExecutionRole"
        effect    = "Allow"
        actions   = ["iam:PassRole"]
        resources = [module.ec2_scheduler_role.aws_iam_role_arn]
        conditions = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["scheduler.amazonaws.com"]
          }
        ]
      }
    }

    security = {
      discovery = {
        sid    = "DiscoverKmsResources"
        effect = "Allow"
        actions = [
          "kms:ListAliases",
          "kms:ListKeys"
        ]
        resources = ["*"]
        conditions = [
          {
            test     = "StringEquals"
            variable = "aws:RequestedRegion"
            values   = ["sa-east-1"]
          }
        ]
      }

      create_werant_encryption_key = {
        sid       = "CreateWerantEncryptionKey"
        effect    = "Allow"
        actions   = ["kms:CreateKey"]
        resources = ["*"]
        conditions = concat([
          {
            test     = "StringEquals"
            variable = "aws:RequestedRegion"
            values   = ["sa-east-1"]
          },
          {
            test     = "StringEquals"
            variable = "kms:KeySpec"
            values   = ["SYMMETRIC_DEFAULT"]
          },
          {
            test     = "StringEquals"
            variable = "kms:KeyUsage"
            values   = ["ENCRYPT_DECRYPT"]
          },
          {
            test     = "StringEquals"
            variable = "kms:KeyOrigin"
            values   = ["AWS_KMS"]
          },
          {
            test     = "Bool"
            variable = "kms:MultiRegion"
            values   = ["false"]
          },
          {
            test     = "BoolIfExists"
            variable = "kms:BypassPolicyLockoutSafetyCheck"
            values   = ["false"]
          }
        ], local.security_kms_request_tag_conditions)
      }

      tag_werant_encryption_key_during_creation = {
        sid     = "TagWerantEncryptionKeyDuringCreation"
        effect  = "Allow"
        actions = ["kms:TagResource"]
        resources = [
          local.security_kms_key_arn
        ]
        conditions = concat([
          {
            test     = "StringEquals"
            variable = "aws:RequestedRegion"
            values   = ["sa-east-1"]
          },
          {
            test     = "StringEquals"
            variable = "kms:KeySpec"
            values   = ["SYMMETRIC_DEFAULT"]
          },
          {
            test     = "StringEquals"
            variable = "kms:KeyUsage"
            values   = ["ENCRYPT_DECRYPT"]
          },
          {
            test     = "StringEquals"
            variable = "kms:KeyOrigin"
            values   = ["AWS_KMS"]
          },
          {
            test     = "Bool"
            variable = "kms:MultiRegion"
            values   = ["false"]
          }
        ], local.security_kms_request_tag_conditions)
      }

      manage_werant_encryption_keys = {
        sid    = "ManageWerantEncryptionKeys"
        effect = "Allow"
        actions = [
          "kms:CancelKeyDeletion",
          "kms:DescribeKey",
          "kms:EnableKey",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:ListResourceTags",
          "kms:UpdateKeyDescription"
        ]
        resources = [
          local.security_kms_key_arn
        ]
        conditions = local.security_kms_resource_tag_conditions
      }

      manage_werant_encryption_key_policies = {
        sid     = "ManageWerantEncryptionKeyPolicies"
        effect  = "Allow"
        actions = ["kms:PutKeyPolicy"]
        resources = [
          local.security_kms_key_arn
        ]
        conditions = concat([
          {
            test     = "StringEquals"
            variable = "kms:PolicyName"
            values   = ["default"]
          },
          {
            test     = "BoolIfExists"
            variable = "kms:BypassPolicyLockoutSafetyCheck"
            values   = ["false"]
          }
        ], local.security_kms_resource_tag_conditions)
      }

      rotate_werant_encryption_keys = {
        sid     = "RotateWerantEncryptionKeysEveryNinetyDays"
        effect  = "Allow"
        actions = ["kms:EnableKeyRotation"]
        resources = [
          local.security_kms_key_arn
        ]
        conditions = concat([
          {
            test     = "NumericEquals"
            variable = "kms:RotationPeriodInDays"
            values   = ["90"]
          }
        ], local.security_kms_resource_tag_conditions)
      }

      schedule_werant_encryption_key_deletion = {
        sid     = "ScheduleWerantEncryptionKeyDeletion"
        effect  = "Allow"
        actions = ["kms:ScheduleKeyDeletion"]
        resources = [
          local.security_kms_key_arn
        ]
        conditions = concat([
          {
            test     = "NumericEquals"
            variable = "kms:ScheduleKeyDeletionPendingWindowInDays"
            values   = ["30"]
          }
        ], local.security_kms_resource_tag_conditions)
      }

      manage_werant_encryption_key_tags = {
        sid     = "ManageWerantEncryptionKeyTags"
        effect  = "Allow"
        actions = ["kms:TagResource"]
        resources = [
          local.security_kms_key_arn
        ]
        conditions = concat(local.security_kms_resource_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.security_kms_common_tags), ["Workload"])
          }
        ])
      }

      manage_werant_encryption_aliases = {
        sid    = "ManageWerantEncryptionAliases"
        effect = "Allow"
        actions = [
          "kms:CreateAlias",
          "kms:DeleteAlias",
          "kms:UpdateAlias"
        ]
        resources = [
          local.security_resources.auth_envelope_kms.alias_arn,
          local.security_resources.application_storage_kms.alias_arn
        ]
      }

      associate_werant_encryption_aliases = {
        sid    = "AssociateWerantEncryptionAliases"
        effect = "Allow"
        actions = [
          "kms:CreateAlias",
          "kms:UpdateAlias"
        ]
        resources = [
          local.security_kms_key_arn
        ]
        conditions = local.security_kms_resource_tag_conditions
      }
    }

    storage = {
      discovery = {
        sid       = "DiscoverS3Buckets"
        effect    = "Allow"
        actions   = ["s3:ListAllMyBuckets"]
        resources = ["*"]
      }

      discover_application_storage_kms_alias = {
        sid       = "DiscoverApplicationStorageKmsAlias"
        effect    = "Allow"
        actions   = ["kms:ListAliases"]
        resources = ["*"]
        conditions = [
          {
            test     = "StringEquals"
            variable = "aws:RequestedRegion"
            values   = ["sa-east-1"]
          },
          {
            test     = "StringEquals"
            variable = "kms:CallerAccount"
            values   = [local.aws_accounts.development]
          }
        ]
      }

      describe_application_storage_kms_key = {
        sid       = "DescribeApplicationStorageKmsKey"
        effect    = "Allow"
        actions   = ["kms:DescribeKey"]
        resources = [local.storage_resources.application_storage_kms.key_arn]
        conditions = [
          {
            test     = "StringEquals"
            variable = "aws:RequestedRegion"
            values   = ["sa-east-1"]
          },
          {
            test     = "StringEquals"
            variable = "aws:ResourceTag/Project"
            values   = [local.security_kms_common_tags.Project]
          },
          {
            test     = "StringEquals"
            variable = "aws:ResourceTag/Workload"
            values   = [local.security_resources.application_storage_kms.tags.Workload]
          },
          {
            test     = "ForAnyValue:StringEquals"
            variable = "kms:ResourceAliases"
            values   = [local.storage_resources.application_storage_kms.alias_name]
          }
        ]
      }

      create_buckets = {
        sid       = "CreateDevelopmentBuckets"
        effect    = "Allow"
        actions   = ["s3:CreateBucket"]
        resources = [local.storage_resources.application_buckets.arn]
        conditions = [
          {
            test     = "StringEquals"
            variable = "s3:locationconstraint"
            values   = ["sa-east-1"]
          }
        ]
      }

      read_bucket_configuration = {
        sid    = "ReadDevelopmentBucketConfiguration"
        effect = "Allow"
        actions = [
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:GetBucketOwnershipControls",
          "s3:GetBucketPolicy",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketTagging",
          "s3:GetBucketVersioning",
          "s3:GetEncryptionConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:ListBucket"
        ]
        resources  = [local.storage_resources.application_buckets.arn]
        conditions = local.storage_bucket_conditions
      }

      manage_bucket_configuration = {
        sid    = "ManageDevelopmentBucketConfiguration"
        effect = "Allow"
        actions = [
          "s3:DeleteBucket",
          "s3:DeleteBucketPolicy",
          "s3:PutBucketOwnershipControls",
          "s3:PutBucketPolicy",
          "s3:PutBucketPublicAccessBlock",
          "s3:PutBucketTagging",
          "s3:PutBucketVersioning",
          "s3:PutEncryptionConfiguration",
          "s3:PutLifecycleConfiguration"
        ]
        resources  = [local.storage_resources.application_buckets.arn]
        conditions = local.storage_bucket_conditions
      }
    }

    messaging = {
      read_execution_role = {
        sid       = "ReadKeyRotationSchedulerExecutionRole"
        effect    = "Allow"
        actions   = ["iam:GetRole"]
        resources = [module.auth_key_rotation_scheduler_role.aws_iam_role_arn]
      }

      read_lambda_alias = {
        sid       = "ReadAuthKeyRotationLambdaAlias"
        effect    = "Allow"
        actions   = ["lambda:GetAlias"]
        resources = [local.auth_key_rotation_alias_arn]
      }

      list = {
        sid    = "DiscoverKeyRotationSchedules"
        effect = "Allow"
        actions = [
          "scheduler:ListScheduleGroups",
          "scheduler:ListSchedules"
        ]
        resources = ["*"]
      }

      create_tagged_group = {
        sid    = "CreateTaggedKeyRotationScheduleGroup"
        effect = "Allow"
        actions = [
          "scheduler:CreateScheduleGroup",
          "scheduler:TagResource"
        ]
        resources = [local.messaging_scheduler_group_arn]
        conditions = concat(local.messaging_scheduler_request_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.messaging_scheduler_common_tags), ["Workload"])
          }
        ])
      }

      read_and_delete_group = {
        sid    = "ManageKeyRotationScheduleGroup"
        effect = "Allow"
        actions = [
          "scheduler:DeleteScheduleGroup",
          "scheduler:GetScheduleGroup",
          "scheduler:ListTagsForResource"
        ]
        resources  = [local.messaging_scheduler_group_arn]
        conditions = local.messaging_scheduler_resource_tag_conditions
      }

      manage_group_tags = {
        sid    = "ManageKeyRotationScheduleGroupTags"
        effect = "Allow"
        actions = [
          "scheduler:TagResource",
          "scheduler:UntagResource"
        ]
        resources = [local.messaging_scheduler_group_arn]
        conditions = concat(local.messaging_scheduler_resource_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = concat(keys(local.messaging_scheduler_common_tags), ["Workload"])
          }
        ])
      }

      manage_schedules = {
        sid    = "ManageKeyRotationSchedules"
        effect = "Allow"
        actions = [
          "scheduler:CreateSchedule",
          "scheduler:DeleteSchedule",
          "scheduler:GetSchedule",
          "scheduler:UpdateSchedule"
        ]
        resources = [local.messaging_scheduler_arn]
      }

      pass_execution_role = {
        sid       = "PassKeyRotationSchedulerExecutionRole"
        effect    = "Allow"
        actions   = ["iam:PassRole"]
        resources = [module.auth_key_rotation_scheduler_role.aws_iam_role_arn]
        conditions = [
          {
            test     = "StringEquals"
            variable = "iam:PassedToService"
            values   = ["scheduler.amazonaws.com"]
          }
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
