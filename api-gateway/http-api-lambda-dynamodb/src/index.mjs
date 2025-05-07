// Import DynamoDB client and command utilities from AWS SDK
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  GetCommand,
  DeleteCommand,
} from "@aws-sdk/lib-dynamodb";

// Create a low-level DynamoDB client
const client = new DynamoDBClient({});

// Wrap the low-level client in a DocumentClient for easier JSON-based operations
const dynamo = DynamoDBDocumentClient.from(client);

// Name of the DynamoDB table used
const tableName = "http-crud-tutorial-items";

// Lambda function handler
export const handler = async (event, context) => {
  let body;                   // Will hold the response body
  let statusCode = 200;       // Default HTTP status code is 200 (OK)
  const headers = {
    "Content-Type": "application/json",  // Ensure response is JSON
  };

  try {
    // Switch based on the incoming HTTP route (event.routeKey)
    switch (event.routeKey) {

      // Handle DELETE request for specific item by id
      case "DELETE /items/{id}":
        await dynamo.send(
          new DeleteCommand({
            TableName: tableName,                   // Table to delete from
            Key: {
              id: event.pathParameters.id,         // Item key (id) from path
            },
          })
        );
        body = `Deleted item ${event.pathParameters.id}`;  // Success message
        break;

      // Handle GET request for a specific item by id
      case "GET /items/{id}":
        body = await dynamo.send(
          new GetCommand({
            TableName: tableName,                   // Table to get from
            Key: {
              id: event.pathParameters.id,         // Item key (id) from path
            },
          })
        );
        body = body.Item;                          // Extract the item from response
        break;

      // Handle GET request for all items (scan entire table)
      case "GET /items":
        body = await dynamo.send(
          new ScanCommand({ TableName: tableName })  // Scan command (returns all items)
        );
        body = body.Items;                          // Extract items array
        break;

      // Handle PUT request to add a new item
      case "PUT /items":
        let requestJSON = JSON.parse(event.body);    // Parse request body as JSON
        await dynamo.send(
          new PutCommand({
            TableName: tableName,                   // Table to put into
            Item: {
              id: requestJSON.id,                  // Item id
              price: requestJSON.price,            // Item price
              name: requestJSON.name,              // Item name
            },
          })
        );
        body = `Put item ${requestJSON.id}`;        // Success message
        break;

      // Handle unsupported routes
      default:
        throw new Error(`Unsupported route: "${event.routeKey}"`);
    }
  } catch (err) {
    statusCode = 400;             // On error, set HTTP status to 400 (Bad Request)
    body = err.message;           // Return error message
  } finally {
    body = JSON.stringify(body);  // Convert response body to JSON string
  }

  // Return HTTP response
  return {
    statusCode,
    body,
    headers,
  };
};
