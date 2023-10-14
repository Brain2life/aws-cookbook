# Deploy single EC2 instance with parameters

Parameters specified:
- AMI ID
- Instance Type
- VPC ID
- SSH Key Pair Name

To deploy SSH key pairs via AWS CLI use:
```shell
 aws ec2 create-key-pair --key-name DemoKeyPair --query 'KeyMaterial' --output text > DemoKeyPair.pem
 chmod 400 DemoKeyPair
```

More info at ["How to launch a single EC2 instance via AWS CLI"](https://brain2life.hashnode.dev/how-to-launch-a-single-ec2-instance-via-aws-cli)