# -----------------------------------------------------------------------------
# Arquivo: providers.tf
# Objetivo:
#   Define a versão mínima do Terraform e o provider AWS usado por este ambiente.
#
# Por que este arquivo existe:
#   O Terraform sozinho não sabe criar recursos na AWS. O provider AWS é o plugin
#   que permite ao Terraform gerenciar recursos como VPC, subnets, route tables,
#   Internet Gateway, NAT Gateway, Security Groups, EC2, RDS e outros serviços.
#
# Neste projeto:
#   O ambiente prod-style usa a AWS na região us-east-1.
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}