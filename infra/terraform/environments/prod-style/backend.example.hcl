# -----------------------------------------------------------------------------
# Arquivo: backend.example.hcl
# Objetivo:
#   Serve como exemplo de configuração do backend remoto do Terraform.
#
# Como usar:
#   Copie este arquivo para backend.hcl e troque o nome do bucket pelo bucket real
#   criado na sua conta AWS.
#
# Observação importante:
#   O arquivo backend.hcl será local e não deve ser commitado se tiver valores
#   específicos da sua conta AWS.
# -----------------------------------------------------------------------------

bucket       = "beyud-platform-tfstate-CHANGE_ME"
key          = "beyud-platform/prod-style/terraform.tfstate"
region       = "us-east-1"
encrypt      = true
use_lockfile = true