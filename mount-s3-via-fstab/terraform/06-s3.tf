################################################################################### 
# S3 Private Bucket
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
###################################################################################

data "aws_caller_identity" "current" {} # Get current caller IAM Account ID

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  # Enable control over object ownership
  control_object_ownership = true # Enforces ownership settings for objects in the bucket

  # Set ownership to ObjectWriter, meaning the object writer retains ownership
  object_ownership = "ObjectWriter" # Objects are owned by the account that uploads them

  versioning = {
    enabled = true
  }
}