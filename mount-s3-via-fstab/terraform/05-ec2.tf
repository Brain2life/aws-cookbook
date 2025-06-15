###################################################################################### 
# EC2 Instance
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
######################################################################################
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]

  associate_public_ip_address = true

  ami = data.aws_ami.s3_mount.id # Specify AMI with S3 mount client installed and created by Packer

  vpc_security_group_ids = [module.security_group_instance.security_group_id]

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" # IAM permissions for SSM connection
    AmazonS3FullAccess           = "arn:aws:iam::aws:policy/AmazonS3FullAccess"           # IAM permissions for S3 full access
    # AmazonS3ReadOnlyAccess       = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"       # IAM permissions for S3 read-only access
  }

  tags = local.tags

}