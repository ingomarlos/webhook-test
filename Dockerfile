#
# ---- Docker Multi-stage Builds: Base ---- #
#
FROM docker.io/library/ubuntu:21.04 AS base
FROM base AS build-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y apt-utils \
    rsync \
    git \
    curl \
    jq \
    python3 \
    python3-pip \
    bash \
    unzip \
    tar \
    wget \
    amazon-ecr-credential-helper \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    openssh-client \
    software-properties-common \
    && apt-get dist-upgrade -y  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && \
    curl -o awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && rm -rf aws/ awscliv2.zip

ENTRYPOINT ["sh", "-o", "pipefail", "-c"]

#
# ---- Docker Multi-stage Builds: Downloader ----  #
#
FROM build-base AS downloader

ARG TERRAGRUNT_VERSION
ARG TERRAFORM_VERSION

WORKDIR /downloads

# download terragrunt
RUN terragruntVersion=$TERRAGRUNT_VERSION && \
    wget https://github.com/gruntwork-io/terragrunt/releases/download/${terragruntVersion}/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 terragrunt && \
    chmod +x terragrunt

# download terraform
RUN terraformVersion=$TERRAFORM_VERSION && \
    curl -o terraform_${terraformVersion}_linux_amd64.zip https://releases.hashicorp.com/terraform/${terraformVersion}/terraform_${terraformVersion}_linux_amd64.zip && \
    unzip /downloads/terraform_${terraformVersion}_linux_amd64.zip && \
    chmod +x terraform

#
# ---- Docker Multi-stage Builds: Builder ---- #
# -------------------------------------------- #
#   latest release of the DevOps tools below   #
# -------------------------------------------- #
#
# Terragrunt
# Terraform
# aws-cli v2
#
FROM build-base AS builder

LABEL maintainer="Interos DevOps Team"

COPY --from=downloader /downloads/terraform /downloads/terragrunt /usr/local/bin
