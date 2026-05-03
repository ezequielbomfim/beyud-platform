# -----------------------------------------------------------------------------
# Arquivo: main.tf
# Objetivo:
#   Cria a fundação de rede AWS da BEYUD Platform.
#
# Por que este arquivo existe:
#   Este módulo é responsável por criar VPC, subnets, Internet Gateway,
#   NAT Gateway, route tables e associações de route tables.
#
# Neste projeto:
#   As subnets públicas serão usadas futuramente por recursos de borda, como
#   ALB e NAT Gateway.
#
#   As subnets privadas de aplicação serão usadas futuramente pelos nós
#   EC2 do RKE2/Kubernetes.
#
#   As subnets privadas de dados serão usadas futuramente pelo RDS PostgreSQL.
#
#   A subnet privada de gerenciamento será usada futuramente pelo Rancher
#   e componentes administrativos.
#
# Observação de custo:
#   Este módulo cria um NAT Gateway. NAT Gateway possui custo por hora e custo
#   por processamento de dados. Para este projeto production-style, usamos apenas
#   um NAT Gateway para reduzir custo, mantendo o padrão de saída controlada das
#   subnets privadas para a internet.
# -----------------------------------------------------------------------------

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  public_subnet_names = [
    "${local.name_prefix}-public-a",
    "${local.name_prefix}-public-b"
  ]

  private_app_subnet_names = [
    "${local.name_prefix}-private-app-a",
    "${local.name_prefix}-private-app-b"
  ]

  private_data_subnet_names = [
    "${local.name_prefix}-private-data-a",
    "${local.name_prefix}-private-data-b"
  ]

  private_mgmt_subnet_names = [
    "${local.name_prefix}-private-mgmt-a"
  ]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
      Tier = "network"
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-igw"
      Tier = "edge"
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = local.public_subnet_names[count.index]
      Tier = "public"
      Role = "edge"
    }
  )
}

resource "aws_subnet" "private_app" {
  count = length(var.private_app_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_app_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = local.private_app_subnet_names[count.index]
      Tier = "private"
      Role = "application"
    }
  )
}

resource "aws_subnet" "private_data" {
  count = length(var.private_data_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_data_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = local.private_data_subnet_names[count.index]
      Tier = "private"
      Role = "data"
    }
  )
}

resource "aws_subnet" "private_mgmt" {
  count = length(var.private_mgmt_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_mgmt_subnets[count.index]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = local.private_mgmt_subnet_names[count.index]
      Tier = "private"
      Role = "management"
    }
  )
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-nat-eip"
      Tier = "edge"
    }
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-nat-gateway"
      Tier = "edge"
    }
  )

  depends_on = [
    aws_internet_gateway.this
  ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-public-rt"
      Tier = "public"
    }
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-app-rt"
      Tier = "private"
      Role = "application"
    }
  )
}

resource "aws_route" "private_app_nat_access" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_app" {
  count = length(aws_subnet.private_app)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table" "private_data" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-data-rt"
      Tier = "private"
      Role = "data"
    }
  )
}

resource "aws_route_table_association" "private_data" {
  count = length(aws_subnet.private_data)

  subnet_id      = aws_subnet.private_data[count.index].id
  route_table_id = aws_route_table.private_data.id
}

resource "aws_route_table" "private_mgmt" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name_prefix}-private-mgmt-rt"
      Tier = "private"
      Role = "management"
    }
  )
}

resource "aws_route" "private_mgmt_nat_access" {
  route_table_id         = aws_route_table.private_mgmt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_mgmt" {
  count = length(aws_subnet.private_mgmt)

  subnet_id      = aws_subnet.private_mgmt[count.index].id
  route_table_id = aws_route_table.private_mgmt.id
}