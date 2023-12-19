#! /bin/bash
set -e

# TODO: Add a check to see if the .env file exists

# Read the environment variables
source .env

# Add the Azure Logic App CLI extension.
az extension add --yes --source "https://aka.ms/logicapp-latest-py2.py3-none-any.whl"

mkdir -p $ARCHIVE_DIR

cp -r $PROJECT_DIR/* $ARCHIVE_DIR

cd $ARCHIVE_DIR

# Rename
rm parameters.json
mv parameters.azure.json parameters.json

# Build the zip file
zip -r $ZIP_FILE_PATH . -x \*workflow-designtime\* \*Artifacts\* \*lib\* requirements.txt send-notifications.py local.settings.*

# Move back to the root directory
cd ..

# NOTE: The az logicapp deployment command seems to generate an error on deployment (still in preview).
#       Using the az functionapp deployment command instead.
# az logicapp deployment source config-zip \
#     --name $LOGIC_APP_NAME \
#     --resource-group $RESOURCE_GROUP \
#     --subscription $SUBSCRIPTION_ID \
#     --src $ARCHIVE_DIR/$ZIP_FILE_PATH 

az functionapp deployment source config-zip \
    --src $ARCHIVE_DIR/$ZIP_FILE_PATH \
    --name $LOGIC_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --subscription $SUBSCRIPTION_ID