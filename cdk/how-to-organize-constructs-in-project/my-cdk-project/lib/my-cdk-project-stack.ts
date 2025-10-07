import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { SecureS3Bucket } from './constructs/secure-s3-bucket'; // <-- IMPORT IT

export class MyCdkProjectStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Instantiate your custom construct just like any other CDK construct
    const mySecureBucket = new SecureS3Bucket(this, 'MyWebsiteData', {
      // You can still override properties if you allow it via props
      bucketName: 'my-unique-website-data-bucket-12345',
    });

    // You can access the underlying resources via public properties
    new cdk.CfnOutput(this, 'BucketNameOutput', {
      value: mySecureBucket.bucket.bucketName,
    });
  }
}