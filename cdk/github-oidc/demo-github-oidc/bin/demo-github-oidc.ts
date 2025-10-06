#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { DemoGithubOidcStack } from '../lib/demo-github-oidc-stack';

const app = new cdk.App();
new DemoGithubOidcStack(app, 'DemoGithubOidcStack', {
  env: { account: '951043241862', region: 'us-east-1' },
});