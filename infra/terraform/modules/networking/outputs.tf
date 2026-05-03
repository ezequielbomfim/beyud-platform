# -----------------------------------------------------------------------------
# Arquivo: outputs.tf
# Objetivo:
#   Expõe valores criados pelo módulo networking.
#
# Por que este arquivo existe:
#   Outputs de módulo permitem que o ambiente acesse IDs de recursos criados
#   dentro do módulo. Sem outputs, o ambiente raiz não conseguiria visualizar
#   facilmente o ID da VPC, IDs das subnets, IDs das route tables e gateways.
#
# Neste projeto:
#   Estes outputs serão úteis nas próximas etapas, quando criarmos EC2, RDS,
#   ALB e componentes relacionados ao Kubernetes.
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID da VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "Bloco CIDR da VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas."
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "IDs das subnets privadas de aplicação."
  value       = aws_subnet.private_app[*].id
}

output "private_data_subnet_ids" {
  description = "IDs das subnets privadas de dados."
  value       = aws_subnet.private_data[*].id
}

output "private_mgmt_subnet_ids" {
  description = "IDs das subnets privadas de gerenciamento."
  value       = aws_subnet.private_mgmt[*].id
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway."
  value       = aws_nat_gateway.this.id
}

output "route_table_ids" {
  description = "IDs das route tables criadas pelo módulo networking."
  value = {
    public       = aws_route_table.public.id
    private_app  = aws_route_table.private_app.id
    private_data = aws_route_table.private_data.id
    private_mgmt = aws_route_table.private_mgmt.id
  }
}