import boto3
from PIL import Image
import io

s3_client = boto3.client('s3')

def resize_image(image_content):
    with Image.open(io.BytesIO(image_content)) as image:
        image.thumbnail((128, 128))
        buffer = io.BytesIO()
        image.save(buffer, 'JPEG')
        buffer.seek(0)
        return buffer

def lambda_handler(event, context):
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    
    # Fetch the image from the original-images-bucket
    response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
    image_content = response['Body'].read()

    # Resize the image
    resized_image_buffer = resize_image(image_content)
    
    # Save the resized image to the resized-images-bucket
    output_key = 'resized_' + file_key
    s3_client.put_object(Bucket='resized-images-566571321054', Key=output_key, Body=resized_image_buffer, ContentType='image/jpeg')

    return {
        'statusCode': 200,
        'body': f"Image {file_key} successfully resized and saved to resized-images-bucket"
    }
