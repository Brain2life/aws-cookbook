import { Stack, StackProps, CfnOutput, RemovalPolicy, aws_s3 as s3 } from 'aws-cdk-lib';
import { Construct } from 'constructs';

export class CdkPrivateBucketStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    // Create the secure, private S3 bucket
    const privateBucket = new s3.Bucket(this, 'MySecurePrivateBucket', {
      
      // 1. Block all public access. This is the default in CDK for new buckets,
      // but it's good to be explicit for security.
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,

      // 2. Enforce encryption at rest. Here, we use S3-managed keys.
      encryption: s3.BucketEncryption.S3_MANAGED,

      // 3. Enforce SSL/TLS for all requests. Rejects any request made over HTTP.
      enforceSSL: true,

      // 4. Enable versioning to protect against accidental deletions/overwrites.
      versioned: true,

      // 5. Set the removal policy to RETAIN. This prevents the bucket from being
      // deleted when the CDK stack is destroyed. For production buckets, this is a
      // critical safety feature. For development/testing, you might use DESTROY.
      removalPolicy: RemovalPolicy.RETAIN,

      // For stacks that use RemovalPolicy.DESTROY, you might need this to automatically
      // delete objects upon bucket deletion. Be very careful with this in production.
      // autoDeleteObjects: true, 
    });

    // Output the name of the bucket
    new CfnOutput(this, 'PrivateBucketName', {
      value: privateBucket.bucketName,
      description: 'The name of the secure private S3 bucket',
    });
  }
}