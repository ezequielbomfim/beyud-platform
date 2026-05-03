# -----------------------------------------------------------------------------
# Arquivo: variables.tf
# Objetivo:
#   Define as variáveis de entrada usadas pelo ambiente prod-style.
#
# Por que este arquivo existe:
#   As variáveis evitam que valores importantes fiquem fixos diretamente no
#   main.tf. Isso deixa o código mais organizado, reutilizável e fácil de alterar.
#
# Neste projeto:
#   Estas variáveis definem a região AWS, nome do projeto, nome do ambiente,
#   CIDR da VPC, CIDRs das subnets, Availability Zones e tags padrão.
# -----------------------------------------------------------------------------

variable "aws_region" {
  description = "Região AWS onde a infraestrutura da BEYUD Platform será provisionada."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto usado para nomear e taguear os recursos."
  type        = string
  default     = "beyud-platform"
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
  default     = "prod-style"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC da BEYUD Platform."
  type        = string
  default     = "10.60.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones usadas pelo módulo de rede."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Blocos CIDR das subnets públicas."
  type        = list(string)
  default     = ["10.60.0.0/24", "10.60.1.0/24"]
}

variable "private_app_subnets" {
  description = "Blocos CIDR das subnets privadas de aplicação."
  type        = list(string)
  default     = ["10.60.10.0/24", "10.60.11.0/24"]
}

variable "private_data_subnets" {
  description = "Blocos CIDR das subnets privadas de dados."
  type        = list(string)
  default     = ["10.60.20.0/24", "10.60.21.0/24"]
}

variable "private_mgmt_subnets" {
  description = "Blocos CIDR das subnets privadas de gerenciamento."
  type        = list(string)
  default     = ["10.60.30.0/24"]
}

variable "common_tags" {
  description = "Tags padrão aplicadas aos recursos suportados."
  type        = map(string)

  default = {
    Project     = "beyud-platform"
    Environment = "prod-style"
    ManagedBy   = "terraform"
    Owner       = "ezequiel-bomfim"
  }
}