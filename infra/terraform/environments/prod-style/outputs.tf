# -----------------------------------------------------------------------------
# Arquivo: outputs.tf
# Objetivo:
#   Expõe valores importantes criados pelo ambiente prod-style.
#
# Por que este arquivo existe:
#   Outputs facilitam visualizar IDs e informações relevantes após o terraform
#   apply. Eles também podem ser úteis futuramente caso outra stack Terraform
#   precise consumir valores deste ambiente.
#
# Neste projeto:
#   Estes outputs expõem informações da VPC, subnets, route tables, Internet
#   Gateway e NAT Gateway.
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID da VPC da BEYUD Platform."
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "Bloco CIDR da VPC da BEYUD Platform."
  value       = module.networking.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas."
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs das subnets privadas de aplicação."
  value       = module.networking.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "IDs das subnets privadas de dados."
  value       = module.networking.private_data_subnet_ids
}

output "private_mgmt_subnet_ids" {
  description = "IDs das subnets privadas de gerenciamento."
  value       = module.networking.private_mgmt_subnet_ids
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway."
  value       = module.networking.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway."
  value       = module.networking.nat_gateway_id
}

output "route_table_ids" {
  description = "IDs das route tables criadas para a rede da BEYUD Platform."
  value       = module.networking.route_table_ids
}