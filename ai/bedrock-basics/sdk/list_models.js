// This line imports the necessary module to handle file paths. It's used to check if the script is being run directly.
import { fileURLToPath } from "node:url";

// This imports the Bedrock client and a specific command from the AWS SDK.
// BedrockClient is what you use to connect to the Bedrock service.
// ListFoundationModelsCommand is the specific API call to list the models.
import {
  BedrockClient,
  ListFoundationModelsCommand,
} from "@aws-sdk/client-bedrock";

// This sets the AWS Region where you want to list the models.
const REGION = "us-east-1";
// This creates a new Bedrock client object, configured with the specified region.
const client = new BedrockClient({ region: REGION });

// This is the main function that contains all the logic.
export const main = async () => {
  // A command object is created for the ListFoundationModels API call.
  // The empty object `{}` means we're not passing any specific parameters, so it will list all models.
  const command = new ListFoundationModelsCommand({});

  // The client sends the command to the Bedrock service, and we wait for the response.
  const response = await client.send(command);
  // The model summaries are extracted from the response.
  const models = response.modelSummaries;

  console.log("Listing the available Bedrock foundation models:");

  // The code then loops through each model summary and prints its details to the console.
  for (const model of models) {
    console.log("=".repeat(42));
    console.log(` Model: ${model.modelId}`);
    console.log("-".repeat(42));
    console.log(` Name: ${model.modelName}`);
    console.log(` Provider: ${model.providerName}`);
    console.log(` Model ARN: ${model.modelArn}`);
    console.log(` Input modalities: ${model.inputModalities}`);
    console.log(` Output modalities: ${model.outputModalities}`);
    console.log(` Supported customizations: ${model.customizationsSupported}`);
    console.log(` Supported inference types: ${model.inferenceTypesSupported}`);
    console.log(` Lifecycle status: ${model.modelLifecycle.status}`);
    console.log(`${"=".repeat(42)}\n`);
  }

  // Finally, the code counts how many models are "ACTIVE" and "LEGACY" and prints the results.
  const active = models.filter(
    (m) => m.modelLifecycle.status === "ACTIVE",
  ).length;
  const legacy = models.filter(
    (m) => m.modelLifecycle.status === "LEGACY",
  ).length;

  console.log(
    `There are ${active} active and ${legacy} legacy foundation models in ${REGION}.`,
  );

  // The function returns the full response object for potential further use.
  return response;
};

// This conditional statement ensures the main function is called only when the script is run directly from the command line,
// not when it's imported as a module by another script.
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  await main();
}