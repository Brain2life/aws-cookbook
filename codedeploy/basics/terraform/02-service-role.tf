# This component creates IAM Service Role for CodeDeploy Service
# For more information, see https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-service-role.html#getting-started-get-service-role-console

# Regional principal (restrict only to us-east-1 region)
data "aws_iam_policy_document" "codedeploy_assume_role_regional" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.us-east-1.amazonaws.com"] # Limit with specific CodeDeploy Service in region
    }
  }
}
resource "aws_iam_role" "codedeploy_service_role" {
  name               = "CodeDeployServiceRole"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role_regional.json
}

# -----------------------------------------
# Permissions policy for EC2/ASG/ELB/etc.
# -----------------------------------------
data "aws_iam_policy_document" "codedeploy_permissions" {
  statement {
    sid    = "CodeDeployEc2AsgElbCore"
    effect = "Allow"
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DeleteLifecycleHook",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:PutLifecycleHook",
      "autoscaling:RecordLifecycleActionHeartbeat",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:EnableMetricsCollection",
      "autoscaling:DescribePolicies",
      "autoscaling:DescribeScheduledActions",
      "autoscaling:DescribeNotificationConfigurations",
      "autoscaling:SuspendProcesses",
      "autoscaling:ResumeProcesses",
      "autoscaling:AttachLoadBalancers",
      "autoscaling:AttachLoadBalancerTargetGroups",
      "autoscaling:PutScalingPolicy",
      "autoscaling:PutScheduledUpdateGroupAction",
      "autoscaling:PutNotificationConfiguration",
      "autoscaling:PutWarmPool",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DeleteAutoScalingGroup",

      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:TerminateInstances",
      "ec2:RunInstances",
      "ec2:CreateTags",

      "tag:GetResources",
      "sns:Publish",

      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",

      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets"
    ]
    resources = ["*"]
  }

  # PassRole is best scoped to the specific instance role your ASG uses
  statement {
    sid     = "AllowPassRoleForEc2"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.ec2_instance_role.arn
    ]
  }
}

resource "aws_iam_policy" "codedeploy_permissions" {
  name   = "CodeDeployEc2AsgPermissions"
  policy = data.aws_iam_policy_document.codedeploy_permissions.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_permissions_attach" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = aws_iam_policy.codedeploy_permissions.arn
}
