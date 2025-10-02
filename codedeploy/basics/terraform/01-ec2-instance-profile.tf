# This component creates an Instance Profile with permissions to access S3 buckets.
# This instance role is used by EC2 instances in ASG

# Trust policy: allow EC2 service to assume this role
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "EC2AppInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

# Attach useful managed policies (adjust to your needs)
resource "aws_iam_role_policy_attachment" "ec2_s3" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Instance profile is what the ASG/Launch Template actually attaches to EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2AppInstanceProfile"
  role = aws_iam_role.ec2_instance_role.name
}
