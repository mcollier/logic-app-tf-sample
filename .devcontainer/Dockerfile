FROM mcr.microsoft.com/azure-functions/dotnet:4-dotnet6-core-tools

# Install rynsc and zip
RUN apt-get update \
    && export DEBIAIN_FRONTEND=noninteractive \
    && apt-get install -y \
        rsync \
        zip 