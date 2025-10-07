#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { MyCdkProjectStack } from '../lib/my-cdk-project-stack';

const app = new cdk.App();
new MyCdkProjectStack(app, 'MyCdkProjectStack', {

  // Uses AWS CLI's default profile
  env: { 
    account: process.env.CDK_DEFAULT_ACCOUNT, 
    region: process.env.CDK_DEFAULT_REGION 
  },

});