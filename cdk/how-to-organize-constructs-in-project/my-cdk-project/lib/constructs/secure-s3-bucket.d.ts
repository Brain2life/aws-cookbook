import { Construct } from 'constructs';
import * as s3 from 'aws-cdk-lib/aws-s3';
export interface SecureS3BucketProps extends s3.BucketProps {
}
export declare class SecureS3Bucket extends Construct {
    readonly bucket: s3.Bucket;
    constructor(scope: Construct, id: string, props: SecureS3BucketProps);
}
