# Find the Dockerfile for mcr.microsoft.com/azure-functions/dotnet: 4-dotnet6-core-tools at
# https://github.com/Azure/azure-functions-docker/blob/dev/host/4/bullseye/amd64/dotnet/dotnet-inproc/dotnet-core-tools.Dockerfile

FROM mcr.microsoft.com/azure-functions/dotnet:4-dotnet6-core-tools

# Install rynsc and zip
RUN apt-get update \
    && export DEBIAIN_FRONTEND=noninteractive \
    && apt-get install -y zip 