# -----------------------------------------------------------------------------
# Arquivo: variables.tf
# Objetivo:
#   Define as variáveis de entrada exigidas pelo módulo networking.
#
# Por que este arquivo existe:
#   Um módulo não deve depender diretamente de valores fixos de um ambiente
#   específico. O ambiente envia os valores para o módulo por meio de variáveis.
#
# Neste projeto:
#   O módulo networking recebe metadados do projeto, CIDR da VPC, CIDRs das
#   subnets, Availability Zones e tags padrão.
# -----------------------------------------------------------------------------

variable "project_name" {
  description = "Nome do projeto usado para nomear os recursos."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones usadas pelo módulo de rede."
  type        = list(string)
}

variable "public_subnets" {
  description = "Blocos CIDR das subnets públicas."
  type        = list(string)
}

variable "private_app_subnets" {
  description = "Blocos CIDR das subnets privadas de aplicação."
  type        = list(string)
}

variable "private_data_subnets" {
  description = "Blocos CIDR das subnets privadas de dados."
  type        = list(string)
}

variable "private_mgmt_subnets" {
  description = "Blocos CIDR das subnets privadas de gerenciamento."
  type        = list(string)
}

variable "common_tags" {
  description = "Tags padrão aplicadas aos recursos."
  type        = map(string)
}