######################################################################################################
# Example of IAM role with full permissions to access the Bedrock service.
# An existing user account assumes the role, granting it full access to the Bedrock service.
# To test the role, you have to switch to the custom AmazonBedrockRole from bedrock_iam_user account.
######################################################################################################

# IAM Role for Bedrock
resource "aws_iam_role" "bedrock_role" {
  name = "AmazonBedrockRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::908418199158:user/bedrock_iam_user" # Change this to your user or another role
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach the managed AmazonBedrockFullAccess policy
resource "aws_iam_role_policy_attachment" "bedrock_full_access_attachment" {
  role       = aws_iam_role.bedrock_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}

# Data source to reference the existing IAM user
data "aws_iam_user" "bedrock_user" {
  user_name = "bedrock_iam_user"
}

# Attach a policy to the existing user to allow them to assume the role
resource "aws_iam_user_policy_attachment" "user_assume_role_permission" {
  user       = data.aws_iam_user.bedrock_user.user_name
  policy_arn = aws_iam_policy.bedrock_assume_role_policy.arn
}

# The policy that grants permission to assume the role
resource "aws_iam_policy" "bedrock_assume_role_policy" {
  name = "BedrockRoleAssumeRolePolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : aws_iam_role.bedrock_role.arn
      }
    ]
  })
}