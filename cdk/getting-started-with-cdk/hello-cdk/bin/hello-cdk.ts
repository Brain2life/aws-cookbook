#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { HelloCdkStack } from '../lib/hello-cdk-stack';
import * as dotenv from 'dotenv';

// Load .env variables
dotenv.config();

const app = new cdk.App();
new HelloCdkStack(app, 'HelloCdkStack', {
  /* Uncomment the next line if you know exactly what Account and Region you
   * want to deploy the stack to. This is a recommended approach for production deployments. */
  // env: { account: '590183676219', region: 'us-east-1' },

  // Approach by using .env files
  env: {
    account: process.env.ACCOUNT,
    region: process.env.REGION,
  }

});