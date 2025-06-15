# Define a data source to fetch the latest AMI with S3 Mountpoint client installed
data "aws_ami" "s3_mount" {
  # Ensure the most recent AMI matching the criteria is selected
  most_recent = true

  # Filter AMIs by name, looking for those starting with "s3-mount"
  filter {
    name   = "name"
    values = ["s3-mount*"] # Wildcard matches any AMI name beginning with "s3-mount"
  }

  # Filter AMIs to only include those with HVM virtualization type
  filter {
    name   = "virtualization-type"
    values = ["hvm"] # Specifies Hardware Virtual Machine (HVM) virtualization
  }

  # Restrict the search to AMIs owned by the current AWS account
  owners = ["self"] # Limits results to AMIs created by the account running this code
}