locals {

  aws_accounts = {
    management  = "633697459676"
    development = "904054820030"
  }

  runtime_resources = {
    auth_key_rotation_lambda = {
      function_name  = "werant-auth-key-rotation-dev"
      log_group_name = "/aws/lambda/werant-auth-key-rotation-dev"
    }
  }

  security_resources = {
    auth_envelope_kms = {
      alias_name = "alias/werant-auth-envelope-encryption-dev"
      alias_arn  = "arn:aws:kms:sa-east-1:${local.aws_accounts.development}:alias/werant-auth-envelope-encryption-dev"
      key_arn    = "arn:aws:kms:sa-east-1:${local.aws_accounts.development}:key/*"
      tags = {
        Project     = "Werant"
        Environment = "Development"
        Lifecycle   = "Security"
        ManagedBy   = "Terraform"
        Workload    = "AuthEnvelopeEncryption"
      }
    }
  }

  auth_envelope_kms_request_tag_conditions = [
    for key, value in local.security_resources.auth_envelope_kms.tags : {
      test     = "StringEquals"
      variable = "aws:RequestTag/${key}"
      values   = [value]
    }
  ]

  auth_envelope_kms_resource_tag_conditions = [
    for key, value in local.security_resources.auth_envelope_kms.tags : {
      test     = "StringEquals"
      variable = "aws:ResourceTag/${key}"
      values   = [value]
    } if contains(["Project", "Workload"], key)
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

      create_auth_envelope_key = {
        sid       = "CreateAuthEnvelopeKey"
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
        ], local.auth_envelope_kms_request_tag_conditions)
      }

      tag_auth_envelope_key_during_creation = {
        sid     = "TagAuthEnvelopeKeyDuringCreation"
        effect  = "Allow"
        actions = ["kms:TagResource"]
        resources = [
          local.security_resources.auth_envelope_kms.key_arn
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
        ], local.auth_envelope_kms_request_tag_conditions)
      }

      manage_auth_envelope_key = {
        sid    = "ManageAuthEnvelopeKey"
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
          local.security_resources.auth_envelope_kms.key_arn
        ]
        conditions = local.auth_envelope_kms_resource_tag_conditions
      }

      manage_auth_envelope_key_policy = {
        sid     = "ManageAuthEnvelopeKeyPolicy"
        effect  = "Allow"
        actions = ["kms:PutKeyPolicy"]
        resources = [
          local.security_resources.auth_envelope_kms.key_arn
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
        ], local.auth_envelope_kms_resource_tag_conditions)
      }

      rotate_auth_envelope_key = {
        sid     = "RotateAuthEnvelopeKeyEveryNinetyDays"
        effect  = "Allow"
        actions = ["kms:EnableKeyRotation"]
        resources = [
          local.security_resources.auth_envelope_kms.key_arn
        ]
        conditions = concat([
          {
            test     = "NumericEquals"
            variable = "kms:RotationPeriodInDays"
            values   = ["90"]
          }
        ], local.auth_envelope_kms_resource_tag_conditions)
      }

      schedule_auth_envelope_key_deletion = {
        sid     = "ScheduleAuthEnvelopeKeyDeletion"
        effect  = "Allow"
        actions = ["kms:ScheduleKeyDeletion"]
        resources = [
          local.security_resources.auth_envelope_kms.key_arn
        ]
        conditions = concat([
          {
            test     = "NumericEquals"
            variable = "kms:ScheduleKeyDeletionPendingWindowInDays"
            values   = ["30"]
          }
        ], local.auth_envelope_kms_resource_tag_conditions)
      }

      manage_auth_envelope_key_tags = {
        sid     = "ManageAuthEnvelopeKeyTags"
        effect  = "Allow"
        actions = ["kms:TagResource"]
        resources = [
          local.security_resources.auth_envelope_kms.key_arn
        ]
        conditions = concat(local.auth_envelope_kms_resource_tag_conditions, [
          {
            test     = "ForAllValues:StringEquals"
            variable = "aws:TagKeys"
            values   = keys(local.security_resources.auth_envelope_kms.tags)
          }
        ])
      }

      manage_auth_envelope_alias = {
        sid    = "ManageAuthEnvelopeAlias"
        effect = "Allow"
        actions = [
          "kms:CreateAlias",
          "kms:DeleteAlias",
          "kms:UpdateAlias"
        ]
        resources = [
          local.security_resources.auth_envelope_kms.alias_arn
        ]
      }

      associate_auth_envelope_alias = {
        sid    = "AssociateAuthEnvelopeAlias"
        effect = "Allow"
        actions = [
          "kms:CreateAlias",
          "kms:UpdateAlias"
        ]
        resources = [
          local.security_resources.auth_envelope_kms.key_arn
        ]
        conditions = local.auth_envelope_kms_resource_tag_conditions
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
