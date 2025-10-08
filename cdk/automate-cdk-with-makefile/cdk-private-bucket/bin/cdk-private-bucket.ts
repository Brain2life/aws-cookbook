#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { CdkPrivateBucketStack } from '../lib/cdk-private-bucket-stack';

const app = new cdk.App();
new CdkPrivateBucketStack(app, 'CdkPrivateBucketStack', {

  /* The next line to specialize this stack for the AWS Account
   * and Region that are implied by the current CLI configuration. */
  /* For more information, see https://docs.aws.amazon.com/cdk/latest/guide/environments.html */
  env: { account: process.env.CDK_DEFAULT_ACCOUNT, region: process.env.CDK_DEFAULT_REGION },

});