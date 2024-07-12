# aws-devops-reorg

Architecture Diagram

![Reorg AWS Solution ArchitectureV2 drawio](https://github.com/user-attachments/assets/0c4b1d75-5a4e-483d-99d6-45f6304a1f92)

**Branching Model**
This branching model helps organize workflow and collaboration in a Git repository. Here, we'll describe a GitHub branching model using main, develop, and feature branches. This model is commonly known as GitFlow.

![gitflow-github](https://github.com/user-attachments/assets/40bc12f7-94a8-4730-a66f-d239ee4a5c78)


# Terraform Setup and Usage Guide

This repository contains infrastructure as code (IaC) managed using Terraform. Follow the steps below to set up your environment and run Terraform locally.

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Terraform**: Download and install Terraform from the [official website](https://www.terraform.io/downloads.html).
2. **Git**: Install Git from the [official website](https://git-scm.com/downloads).

## Setup Instructions (Locally)

### 1. Clone the Repository

Clone this repository to your local machine using Git:

git clone https://github.com/emmanuel-reorg/aws-devops-reorg.git

2. Initialize Terraform
Navigate to the directory containing the Terraform configuration files (usually main.tf, variables.tf, outputs.tf, etc.). Initialize Terraform to download the necessary provider plugins:

run in your terminal : **terraform init**

3. Plan Your Infrastructure Changes
Review the changes Terraform will make to your infrastructure. This is a safe way to check what will happen without actually applying the changes:

run in your terminal : **terraform plan**

4.- Apply Your Changes
Apply the changes to create, update, or destroy infrastructure resources:

run in your terminal : **terraform apply**

5.- Destroy Your Infrastructure (Optional)
If you need to tear down your infrastructure, use the destroy command:

run in your terminal : **terraform destroy**

Review the proposed changes and type yes to confirm and proceed.


# **Terraform Pipeline Execution using Actions**

**Triggers:** The workflow runs on pushes to the main branch, pull requests targeting main, and manual triggers via workflow_dispatch.

**Jobs and Steps:**

- Checkout Code: Retrieves the repository's code.
- Setup Terraform: Installs the specified version of Terraform.
- Configure AWS Credentials: Configures AWS credentials using secrets stored in GitHub.
- Terraform Init: Initializes the Terraform working directory.
- Terraform Format: Ensures the Terraform files are properly formatted.
- Terraform Validate: Validates the Terraform configuration.
- Terraform Plan: Creates a plan for the changes to be applied.
- Terraform Plan Status: Checks if the plan includes changes.
- Terraform Apply: Applies the Terraform plan, but only if the main branch is being updated and changes are detected.


