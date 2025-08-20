// Imports the core AWS CDK library, which provides the fundamental building blocks for defining AWS infrastructure.
import * as cdk from 'aws-cdk-lib';
// Imports the 'Construct' class, a foundational building block in the CDK that represents a cloud component.
import { Construct } from 'constructs';
// Import the Lambda module
import * as lambda from 'aws-cdk-lib/aws-lambda';

// Defines a new class named 'HelloCdkStack' that extends the 'cdk.Stack' class.
// A Stack is the unit of deployment in AWS CloudFormation.
export class HelloCdkStack extends cdk.Stack {
  // The constructor is called when a new instance of this stack is created.
  // 'scope': The parent construct to which this stack belongs.
  // 'id': A unique identifier for this stack within its scope.
  // 'props': Optional properties to configure the stack.
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    // Calls the constructor of the parent class (cdk.Stack) to initialize it.
    super(scope, id, props);

    // Define the Lambda function resource
    const myFunction = new lambda.Function(this, "HelloWorldFunction", {
      runtime: lambda.Runtime.NODEJS_20_X, // Provide any supported Node.js runtime
      handler: "index.handler",
      code: lambda.Code.fromInline(`
        exports.handler = async function(event) {
          return {
            statusCode: 200,
            // body: JSON.stringify('Hello World!'),
            // Uncomment below for the modified message
            body: JSON.stringify('Hello, this is my modified message!'),
          };
        };
      `),
    });

    // Define the Lambda function URL resource
    const myFunctionUrl = myFunction.addFunctionUrl({
      authType: lambda.FunctionUrlAuthType.NONE,
    });

    // Define a CloudFormation output for your URL
    new cdk.CfnOutput(this, "myFunctionUrlOutput", {
      value: myFunctionUrl.url,
    })

  }
}
