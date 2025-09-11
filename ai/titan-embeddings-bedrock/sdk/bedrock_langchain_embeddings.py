from langchain_aws import BedrockEmbeddings

# -----------------------
# CREATE THE CLIENT
# -----------------------
# This initializes a LangChain wrapper for Amazon Titan Text Embeddings.  
# Under the hood, it uses boto3 + Bedrock, but LangChain handles all the
# JSON request/response details for you.  
embeddings_client = BedrockEmbeddings() 

# -----------------------
# DEFINE INPUT
# -----------------------
# This is the text you want to embed (turn into a vector of numbers).
# In real-world usage, this could be sentences, paragraphs, or whole documents.
text = "Can you please tell me how to get to the bakery?"

# -----------------------
# CALL THE MODEL
# -----------------------
# This sends the text to Amazon Titan Text Embeddings (via Bedrock).  
# The result is a high-dimensional vector (length ~1536 for Titan v1/v2).
embedding = embeddings_client.embed_query(text)

# -----------------------
# OUTPUT
# -----------------------
# Print the vector. For readability, you might just log the length
# and the first few values instead of dumping all 1536 floats.
print(f"Embedding length: {len(embedding)}")
print("First 8 values:", embedding[:8])
