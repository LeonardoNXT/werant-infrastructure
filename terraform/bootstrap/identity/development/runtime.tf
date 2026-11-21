data "aws_iam_policy_document" "auth_key_rotation_lambda_runtime" {
  statement {
    sid    = "WriteFunctionLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:sa-east-1:${local.aws_accounts.development}:log-group:${local.runtime_resources.auth_key_rotation_lambda.log_group_name}:*"
    ]
  }
}

resource "aws_iam_role_policy" "auth_key_rotation_lambda_runtime" {
  name   = "auth-key-rotation-lambda-runtime-dev"
  role   = module.auth_key_rotation_lambda_role.aws_iam_role_name
  policy = data.aws_iam_policy_document.auth_key_rotation_lambda_runtime.json
}

data "aws_iam_policy_document" "ec2_scheduler_runtime" {
  statement {
    sid    = "ManageWerantDevelopmentApplicationNodePower"
    effect = "Allow"
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    resources = [
      "arn:aws:ec2:sa-east-1:${local.aws_accounts.development}:instance/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"
      values   = ["Werant"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Environment"
      values   = ["Development"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Lifecycle"
      values   = ["Compute"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/ManagedBy"
      values   = ["Terraform"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Workload"
      values   = ["K3sNode"]
    }
  }
}

resource "aws_iam_role_policy" "ec2_scheduler_runtime" {
  name   = "werant-ec2-scheduler-runtime-dev"
  role   = module.ec2_scheduler_role.aws_iam_role_name
  policy = data.aws_iam_policy_document.ec2_scheduler_runtime.json
}

resource "aws_iam_instance_profile" "application" {
  name = "werant-application-ec2-profile-dev"
  role = module.application_ec2_role.aws_iam_role_name

  tags = {
    Project     = "Werant"
    Environment = "Development"
    Lifecycle   = "Identity"
    ManagedBy   = "Terraform"
    Workload    = "ApplicationRuntime"
  }
}
