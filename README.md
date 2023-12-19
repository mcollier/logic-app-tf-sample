# Logic Apps Standard - Terraform Sample

This sample shows one approach for setting up a Logic App via Terraform.  Terraform is used to provision the Azure resources, including a connection to Office 365 for purposes of sending an email.

## Deploy to Azure

### Provision Azure resources

1. Initialize Terraform.

    ```bash
    terraform init
    ```

1. Create a `terraform.tfvars` file for your Terraform variables.

    ```terraform
    location                          = "[YOUR DESIRED AZURE REGION]"
    resource_group_name               = "[YOUR RESOURCE GROUP NAME]"
    log_analytics_workspace_name      = "[YOUR DESIRED LOG ANALYTICS WORKSPACE NAME]"
    application_insights_name         = "[YOUR DESIRED APPLICATION INSIGHTS NAME]"
    logic_app_plan_name               = "[YOUR DESIRED LOGIC APP WORKFLOW PLAN NAME]"
    logic_app_name                    = "[YOUR DESIRED LOGIC APP NAME]"
    logic_app_storage_account_name    = "[YOUR DESIRED STORAGE ACCOUNT NAME FOR USE BY THE LOGIC APP]"
    notification_storage_account_name = "[YORU DESIRED STORAGE ACCOUNT NAME FOR NOTIFICATIONS]"
    ```

1. Plan the Terraform deployment.

    ```bash
    terraform plan
    ```

1. Apply the Terraform plan to provision the resources.

    ```bash
    terraform apply
    ```

## Running locally

### Azure resources

Create a resource group and Azure Storage account to use while developing & testing the Logic App in Visual Studio code.

```bash
az login
az group create --name MyResourceGroup --location eastus

az storage account create \
    --name mystorageaccount \
    --resource-group MyResourceGroup \
    --location eastus \
    --sku Standard_LRS

az storage queue create \
    --name myqueue \
    --account-name mystorageaccount \
    --account-key mystorageaccountkey    
```

### Run the Logic App

1. Modify the included `local.settings.SAMPLE.json` file to include your settings.
1. In the local.settings.json file, set the value of the `notification_queue_connection_string` setting to the connection string of the desired Azure Storage queue.
1. Using Visual Studio Code, open the Logic App in the designer.
1. In the Logic App designer, click to open the "Send an email (V2)" action. Click the "Change connection" link to create a new connection.
    1. Sign into Office 365.
    1. Complete the series of authentication and redirect prompts.
1. Open the newly created "office365" API connection.  Copy the "Connection Runtime Url" from the Properties section and paste into the `OFFICE365_CONNECTION_RUNTIME_URL` setting in the `local.settings.json` file.
1. Use the Visual Studio Code debugger to "Attatch to Logic App".

### Send sample messages

The included `/source/send-notifications.py` Python script will send a message to the designated Azure Storage queue every 1 minute until stopped.

1. Create enviroment variables by creating a `.env` file in the `/source` directory.  Include the name of the Azure Storage account and queue to send messages.

    ```text
    NOTIFICATION_QUEUE_NAME=my-notifications-queue
    NOTIFICATION_STORAGE_ACCOUNT_NAME=stnotifications
    NOTIFICATION_RECIPIENT=you@email.com
    ```

1. Grant yourself permissions to send messages to the queue.

    ```bash
    az role assignment create \
        --assignee [USER-PRINCIPAL-NAME] \
        --role "Storage Queue Data Contributor" \
        --scope /subscriptions/[AZURE-SUBSCRIPTION-ID]/resourceGroups/[RESOURCE-GROUP]]
    ```

1. Run the Python script in the `/source` directory.

    ```bash
    python send-notifications.py
    ```

1. Press Ctrl+C to exit and stop sending messages.

## Deploy Logic App to Azure

### Option - Deployment script

Use the included `deploy-logic-app.sh` to create a zip file and deploy the Logic App.

1. Create a `.env` file containing the following environment variables, substituting your Azure resource values as appropriate:

    ```bash
    LOGIC_APP_NAME="YOUR-LOGIC-APP-NAME"
    RESOURCE_GROUP="YOUR-RESOURCE-GROUP"
    SUBSCRIPTION_ID="YOUR-AZURE-SUBSCRIPTION-ID"
    PROJECT_DIR="./source"
    ARCHIVE_DIR="project_output"
    ZIP_FILE_PATH="workflow.zip"
    ```

1. Run the script.  The script should create a zip file and deploy the zip using the Azure CLI.

### Option - Visual Studio Code

Use the VS Code extension for Logic App Standard to deploy the Logic App to the recently provisioned Logic App resource.

1. Right-click on the `/source` directory and select the "Deploy to Logic App..." context menu option.
1. Select the desired Azure subscription.
1. Select the recently created Logic App resource.
1. Agree to the warning prompt about overwriting previous deployments by clicking the Deploy button.

### Authorize the Office 365 connection

After deploying the workflow to Azure, the Office 365 connection will need authenticated using your Office 365 account.

1. In the Azure portal, click on the "office365" resource.  You should notice a "Test connection failed." error near the top of the page.
1. Click the error to edit the API connection.
1. Click the Authorize button.
1. Authenticate using your Office 365 account.
1. Click the Save button to save the changes.

### Notes

- If while running the Logic App you receive an authentication error on the Office 365 send email task, you may need to create a new API connection
- See [Set up DevOps deployment for Standard logic app workflows in single-tenant Azure Logic Apps](https://learn.microsoft.com/azure/logic-apps/set-up-devops-deployment-single-tenant-azure-logic-apps?tabs=github#create-api-connections-as-needed) for more on creating API connections.

_Credit to <https://gist.github.com/SharonHart> and the post at [Provisioning Azure Logic Apps API Connections with Terraform](https://medium.com/microsoftazure/provisioning-azure-logic-apps-api-connections-with-terraform-980179980b5b)_ for the knowledge on setting up the API connections with Terraform.
