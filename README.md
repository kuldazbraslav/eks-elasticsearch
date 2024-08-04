## Repository Organization

The repository is organized as follows:

- `/terraform`: Contains the source code for building a testing VPC and EKS cluster
- `/elasticsearch`: Helm chart with Elasticsearch instance

## Deployment

To deploy this example Elasticsearch on EKS:

1. Terraform deployment:
   
```
cd terraform
terraform init
terraform plan
terraform apply
```

2. Helm deployment:
   
```
cd elasticsearch
# Follow the instructions in elasticsearch/README.md for Helm deployment
```
