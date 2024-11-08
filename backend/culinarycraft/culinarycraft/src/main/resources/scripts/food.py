import sys
from io import BytesIO
from inference_sdk import InferenceHTTPClient
from PIL import Image

# Initialize Roboflow Inference Client
CLIENT = InferenceHTTPClient(
    api_url="https://outline.roboflow.com",
    api_key="IQMg6q2SBy4BG2RFYbuv"
)

def recognize_food(image_path):

    image = Image.open(image_path)

    # Send the image to Roboflow for inference
    result = CLIENT.infer(image, model_id="food-image-segmentation-yolov5/2")

    # Extract labels (ingredients) from the response
    labels = [item["class"] for item in result["predictions"]]

    # Print recognized ingredients
    print(labels[0])

if __name__ == "__main__":
    # Read the image path from command line arguments
    if len(sys.argv) != 2:
        print("Usage: python main.py <image_path>")
        sys.exit(1)

    image_path = sys.argv[1]
    #print(image_path)
    recognize_food(image_path)
