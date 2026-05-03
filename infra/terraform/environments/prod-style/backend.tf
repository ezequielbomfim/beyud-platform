# -----------------------------------------------------------------------------
# Arquivo: backend.tf
# Objetivo:
#   Define o backend remoto usado pelo Terraform para armazenar o arquivo de state.
#
# Por que este arquivo existe:
#   O Terraform state guarda o relacionamento entre o código Terraform e os
#   recursos reais criados na AWS. Neste projeto, o state será armazenado em um
#   bucket S3, em vez de ficar apenas localmente na máquina.
#
# Observação importante:
#   A configuração de backend não aceita variáveis do Terraform. Por isso, os
#   valores reais do bucket, chave e região serão passados por um arquivo externo
#   chamado backend.hcl durante o comando terraform init.
# -----------------------------------------------------------------------------

terraform {
  backend "s3" {}
}