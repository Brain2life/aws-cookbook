import * as cdk from 'aws-cdk-lib';
import { SqsDestination } from 'aws-cdk-lib/aws-s3-notifications';
import { Bucket, CfnBucket, EventType } from 'aws-cdk-lib/aws-s3';
import { Queue } from 'aws-cdk-lib/aws-sqs';
import { Construct } from 'constructs';
// import * as sqs from 'aws-cdk-lib/aws-sqs';

export class MyCdkDemoAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // L1 Construct of an S3 bucket
    const level1S3Bucket = new CfnBucket(this, "MyLevel1ConstructS3Bucket", {
      bucketName: "my-level1-bucket-905418270714", // Ensure the Bucket name is gloabbly unique
      versioningConfiguration: {
        status: "Enabled"
      }
    });

    // L2 Construct of an S3 bucket
    const level2S3Bucket = new Bucket(this, "MyLevel2ConstructS3Bucket", {
      bucketName: "my-level2-bucket-905418270714",
      versioned: true
    })

    // SQS queue for S3 put event notifications
    const queue = new Queue(this, "MyQueue", {
      queueName: "MyQueue"
    })

    // Add event notification
    level2S3Bucket.addEventNotification(EventType.OBJECT_CREATED, new SqsDestination(queue))
  }
}
