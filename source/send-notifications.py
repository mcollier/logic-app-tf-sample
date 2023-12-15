import time
import datetime
import json
import base64
import os

from dotenv import load_dotenv
from azure.identity import DefaultAzureCredential
from azure.storage.queue import QueueClient

load_dotenv()
credential = DefaultAzureCredential()

queue_name = os.getenv("NOTIFICATION_QUEUE_NAME")
storage_account_name = os.getenv("NOTIFICATION_STORAGE_ACCOUNT_NAME")
storage_account_url = f"https://{storage_account_name}.queue.core.windows.net"

queue = QueueClient(storage_account_url, queue_name, credential=credential)

def send_notification_message(message):
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{current_time} Sending message.")

    queue.send_message(message)

if __name__ == "__main__":

    event_body ={
        "recipient": os.getenv("NOTIFICATION_RECIPIENT"),
        "subject": "Notification regarding incident",
        "incident-date": "2022-01-01T12:00:00Z",
        "priority": "High",
        "body": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, urna vel bibendum bibendum, sapien sapien bibendum sapien, vel bibendum sapien sapien bibendum sapien."
    }

    json_event_body = json.dumps(event_body)

    encoded_string = base64.b64encode(json_event_body.encode()).decode()

    try:
        while True:
            
            send_notification_message(encoded_string)

            # Wait for 1 minute
            time.sleep(60)
    except KeyboardInterrupt:
        print("Program stopped")

