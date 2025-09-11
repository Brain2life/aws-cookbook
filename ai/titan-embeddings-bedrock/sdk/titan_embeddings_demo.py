import boto3
import json

# Create the connection to Bedrock control plane (for listing models, etc.)
bedrock = boto3.client(
    service_name='bedrock',
    region_name='us-east-1', 
)

# Create the runtime client (used to actually invoke a chosen model)
bedrock_runtime = boto3.client(
    service_name='bedrock-runtime',
    region_name='us-east-1', 
)

# List all available foundation models in this account/region
available_models = bedrock.list_foundation_models()

# Print details for all Amazon models (you'll see both text-generation and embedding models)
for model in available_models['modelSummaries']:
  if 'amazon' in model['modelId']:
    print(model)

# -----------------------
# INPUT DATA
# -----------------------
# This is the text you want to process.
# NOTE: with an *embeddings model*, this text will be converted into a vector (list of floats).
#       with a *text-generation model* (like titan-text-express-v1), the model would actually *generate*
#       a new poem as output instead of vectors.
prompt_data = """Write me a poem about DevOps engineering"""

# For embeddings, the payload uses the "inputText" key
body = json.dumps({
    "inputText": prompt_data,
})

# -----------------------
# CHOOSE THE MODEL
# -----------------------
# 'amazon.titan-embed-text-v1' --> Embeddings model
# - Output: vector (numbers only)
#
# If you wanted the *poem itself*, you would switch this to a
# text-generation model like 'amazon.titan-text-express-v1'
# and change the payload key to "prompt".

# model_id = 'amazon.titan-embed-text-v1'
model_id = 'amazon.titan-embed-text-v2:0'

accept = 'application/json' 
content_type = 'application/json'

# -----------------------
# INVOKE THE MODEL
# -----------------------
# Send the request to the Bedrock runtime with the text payload.
# Here it will return an embedding vector instead of natural language text.
response = bedrock_runtime.invoke_model(
    body=body, 
    modelId=model_id, 
    accept=accept, 
    contentType=content_type
)

# -----------------------
# PROCESS THE RESPONSE
# -----------------------
# Parse the JSON response body.
response_body = json.loads(response['body'].read())

# Extract the vector from the "embedding" field.
embedding = response_body.get('embedding')

if not embedding:
    raise RuntimeError(f"No 'embedding' field in response: {response_body}")

# Print the size of the vector and preview first values.
print(f"Model used: {model_id}")
print(f"Embedding length: {len(embedding)}")
print("First 8 values:", embedding[:8])
