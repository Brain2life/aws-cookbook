import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
import { RemovalPolicy } from 'aws-cdk-lib';

// Define the properties your construct will accept
export interface SecureS3BucketProps extends s3.BucketProps {
  // You can add custom properties here if needed
}

export class SecureS3Bucket extends Construct {
  public readonly bucket: s3.Bucket;

  constructor(scope: Construct, id: string, props: SecureS3BucketProps) {
    super(scope, id);

    this.bucket = new s3.Bucket(this, 'SecureBucket', {
      ...props, // Pass through any standard bucket props
      // Enforce your security best practices
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      encryption: s3.BucketEncryption.S3_MANAGED,
      enforceSSL: true,
      versioned: true,
      removalPolicy: RemovalPolicy.RETAIN, // Safer default for production
    });
  }
}