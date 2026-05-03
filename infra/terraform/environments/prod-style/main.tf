# -----------------------------------------------------------------------------
# Arquivo: main.tf
# Objetivo:
#   É o ponto de entrada do ambiente Terraform prod-style.
#
# Por que este arquivo existe:
#   Este arquivo conecta a configuração do ambiente aos módulos reutilizáveis.
#   Em vez de criar todos os recursos diretamente aqui, ele chama o módulo de
#   networking e envia os valores necessários para ele.
#
# Neste projeto:
#   O módulo networking cria a fundação de rede da BEYUD Platform na AWS.
# -----------------------------------------------------------------------------

module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnets       = var.public_subnets
  private_app_subnets  = var.private_app_subnets
  private_data_subnets = var.private_data_subnets
  private_mgmt_subnets = var.private_mgmt_subnets
  common_tags          = var.common_tags
}