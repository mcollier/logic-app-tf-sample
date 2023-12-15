# Logic Apps Standard - Terraform Sample

## Running locally

### Create enviroment variables

Create a `.env` file in the `/source` directory.  Include the name of the Azure Storage account and queue to send messages.

```text
NOTIFICATION_QUEUE_NAME=my-notifications-queue
NOTIFICATION_STORAGE_ACCOUNT_NAME=stnotifications
```
