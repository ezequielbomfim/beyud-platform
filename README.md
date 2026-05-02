Claro. Aqui está **somente o `README.md` pronto, formatado e organizado**:

````md
# BEYUD Platform

A **BEYUD Platform** é uma plataforma pública production-style na AWS, desenhada, implantada e operada ponta a ponta com práticas reais de infraestrutura, automação, Kubernetes, observabilidade e operação em cloud.

O objetivo do projeto é demonstrar, de forma organizada e prática, a construção de uma plataforma moderna baseada em AWS, Terraform, Docker, Kubernetes, RKE2, Rancher, GitHub Actions, Argo CD, Amazon ECR, Amazon RDS PostgreSQL, Prometheus, Grafana, Loki e Promtail.

---

## Objetivo do projeto

Este repositório tem como objetivo documentar e implementar uma plataforma production-style com foco em:

- arquitetura cloud na AWS;
- infraestrutura como código com Terraform;
- aplicações em containers;
- orquestração com Kubernetes RKE2;
- gerenciamento de cluster com Rancher;
- pipelines com GitHub Actions;
- entrega contínua com Argo CD;
- banco de dados gerenciado com Amazon RDS PostgreSQL;
- observabilidade com Prometheus, Grafana, Loki e Promtail;
- documentação técnica e evidências operacionais.

---

## Visão geral da arquitetura

A arquitetura da BEYUD Platform será baseada em uma VPC na AWS, com separação por camadas:

- camada pública e de borda;
- camada privada de aplicação;
- camada privada de dados;
- camada privada de gerenciamento;
- cluster Kubernetes RKE2 em subnets privadas;
- Rancher para gerenciamento do cluster;
- RDS PostgreSQL em subnets privadas de dados;
- ALB público com HTTPS;
- Ingress Controller dentro do cluster;
- observabilidade com métricas, logs e dashboards.

Fluxo principal de entrada pública:

```text
Internet
  -> Route 53
  -> Public ALB HTTPS + ACM
  -> Ingress Controller
  -> beyud-web / beyud-api
````

Fluxo de banco de dados:

```text
beyud-api / beyud-worker
  -> Amazon RDS PostgreSQL
```

Fluxo de gerenciamento:

```text
Rancher Server
  -> RKE2 Kubernetes Cluster
```

Fluxo de saída para internet:

```text
Private App Subnets / Private Mgmt Subnet
  -> NAT Gateway
  -> Internet Gateway
  -> Internet
```

---

## Stack principal

| Categoria                  | Tecnologia                       |
| -------------------------- | -------------------------------- |
| Cloud Provider             | AWS                              |
| Infraestrutura como Código | Terraform                        |
| Containers                 | Docker                           |
| Kubernetes                 | RKE2                             |
| Gerenciamento Kubernetes   | Rancher                          |
| CI/CD                      | GitHub Actions                   |
| GitOps                     | Argo CD                          |
| Registry                   | Amazon ECR                       |
| Banco de dados             | Amazon RDS PostgreSQL            |
| DNS                        | Route 53                         |
| Certificados               | AWS Certificate Manager          |
| Load Balancer              | Public Application Load Balancer |
| Métricas                   | Prometheus                       |
| Dashboards                 | Grafana                          |
| Logs                       | Loki                             |
| Coleta de logs             | Promtail                         |

---

## Aplicações da plataforma

A BEYUD Platform será composta inicialmente por três aplicações principais:

```text
apps/
├── web/
├── api/
└── worker/
```

### beyud-web

Front-end da plataforma, desenvolvido com **React + Vite**.

Páginas previstas:

* `/`
* `/sobre`
* `/servicos`
* `/contato`
* `/status`

---

### beyud-api

API principal da plataforma, desenvolvida com **.NET 8 Web API**.

Endpoints previstos:

* `GET /health`
* `GET /api/status`
* `GET /api/services`
* `POST /api/contact`

---

### beyud-worker

Worker Service em **.NET 8**, responsável por processar contatos pendentes no banco de dados.

Fluxo previsto:

```text
Buscar contatos com status PENDING
  -> processar
  -> atualizar para PROCESSED
  -> gerar logs operacionais
```

---

## Banco de dados

O banco de dados será **PostgreSQL**, hospedado em **Amazon RDS**.

Tabela principal prevista:

```text
contacts
├── id
├── name
├── email
├── company
├── subject
├── message
├── status
├── created_at
└── processed_at
```

Status possíveis:

* `PENDING`
* `PROCESSING`
* `PROCESSED`
* `FAILED`

---

## Arquitetura AWS

A arquitetura AWS definida para a BEYUD Platform utilizará a região:

```text
us-east-1
```

VPC principal:

```text
Nome: beyud-prod-style-vpc
CIDR: 10.60.0.0/16
```

---

## Subnets

| Nome                  | CIDR          | Zona       | Tipo    | Função                      |
| --------------------- | ------------- | ---------- | ------- | --------------------------- |
| Public Subnet A       | 10.60.0.0/24  | us-east-1a | Pública | ALB, NAT Gateway            |
| Public Subnet B       | 10.60.1.0/24  | us-east-1b | Pública | ALB                         |
| Private App Subnet A  | 10.60.10.0/24 | us-east-1a | Privada | RKE2 Node 01 e RKE2 Node 03 |
| Private App Subnet B  | 10.60.11.0/24 | us-east-1b | Privada | RKE2 Node 02                |
| Private Data Subnet A | 10.60.20.0/24 | us-east-1a | Privada | RDS PostgreSQL              |
| Private Data Subnet B | 10.60.21.0/24 | us-east-1b | Privada | RDS PostgreSQL              |
| Private Mgmt Subnet A | 10.60.30.0/24 | us-east-1a | Privada | Rancher Server              |

---

## Componentes AWS

### Route 53

O **Route 53** será responsável pela resolução DNS pública da plataforma.

Fluxo conceitual:

```text
domínio público
  -> Route 53
  -> Public ALB
```

Observação importante:

```text
Route 53 resolve DNS.
Route 53 não atua como proxy de tráfego.
```

---

### AWS Certificate Manager

O **AWS Certificate Manager** será utilizado para gerenciar o certificado TLS/HTTPS da plataforma.

O certificado será associado ao Public Application Load Balancer.

---

### Public Application Load Balancer

O **Public ALB** será responsável por receber o tráfego HTTPS da internet.

Ele ficará associado às duas subnets públicas:

```text
Public Subnet A
Public Subnet B
```

Fluxo:

```text
Internet
  -> Route 53
  -> Public ALB HTTPS + ACM
  -> Ingress Controller
```

---

### NAT Gateway

O **NAT Gateway** será utilizado para permitir saída controlada para internet a partir das subnets privadas.

Uso previsto:

* atualizações do sistema operacional;
* downloads de pacotes;
* pull de imagens;
* comunicação de componentes privados com serviços externos autorizados.

Fluxo:

```text
Private App Subnets / Private Mgmt Subnet
  -> NAT Gateway
  -> Internet Gateway
  -> Internet
```

---

### Amazon RDS PostgreSQL

O **Amazon RDS PostgreSQL** será utilizado como banco de dados gerenciado da plataforma.

O RDS ficará nas subnets privadas de dados, sem exposição pública.

Fluxo:

```text
beyud-api / beyud-worker
  -> Amazon RDS PostgreSQL:5432
```

---

## Kubernetes

A distribuição Kubernetes definida para o projeto é:

```text
RKE2
```

O cluster será composto por três nodes EC2 privados:

| Node               | Subnet               | Zona       |
| ------------------ | -------------------- | ---------- |
| EC2 - RKE2 Node 01 | Private App Subnet A | us-east-1a |
| EC2 - RKE2 Node 02 | Private App Subnet B | us-east-1b |
| EC2 - RKE2 Node 03 | Private App Subnet A | us-east-1a |

Os nodes ficarão em subnets privadas de aplicação e não serão expostos diretamente à internet.

---

## Entrada de tráfego no cluster

O tráfego público chegará ao cluster pelo seguinte fluxo:

```text
Internet
  -> Route 53
  -> Public ALB HTTPS + ACM
  -> Ingress Controller
  -> Kubernetes Services
  -> Pods
```

O **Ingress Controller** será responsável por encaminhar as requisições para os serviços internos do Kubernetes.

---

## Workloads previstos no cluster

| Workload     | Função                           |
| ------------ | -------------------------------- |
| beyud-web    | Front-end React + Vite           |
| beyud-api    | API .NET 8 Web API               |
| beyud-worker | Worker Service .NET 8            |
| Argo CD      | GitOps e entrega contínua        |
| Prometheus   | Coleta de métricas               |
| Grafana      | Dashboards                       |
| Loki         | Armazenamento e consulta de logs |
| Promtail     | Coleta de logs                   |

---

## Rancher

O **Rancher Server** será utilizado para gerenciamento do cluster RKE2.

Ele será executado em uma EC2 privada na camada de gerenciamento:

```text
Private Mgmt Subnet A
└── Rancher Server
```

Fluxo de gerenciamento:

```text
Rancher Server
  -> RKE2 Kubernetes Cluster
```

---

## CI/CD e GitOps

A estratégia de CI/CD e GitOps da BEYUD Platform será baseada em:

* GitHub Actions para integração contínua;
* Amazon ECR para armazenamento de imagens;
* Argo CD para entrega contínua baseada em GitOps;
* Kubernetes RKE2 como ambiente de execução.

Fluxo planejado:

```text
Código no GitHub
  -> GitHub Actions
  -> Build e testes
  -> Build da imagem Docker
  -> Push para Amazon ECR
  -> Atualização dos manifestos Kubernetes
  -> Argo CD detecta mudança
  -> Argo CD sincroniza o cluster
  -> Aplicação atualizada no RKE2
```

---

## GitHub Actions

O **GitHub Actions** será responsável pela etapa de integração contínua.

Responsabilidades previstas:

* validar código;
* executar testes;
* gerar build das aplicações;
* construir imagens Docker;
* autenticar no Amazon ECR;
* publicar imagens no registry;
* atualizar referências de imagem nos manifestos Kubernetes.

---

## Amazon ECR

O **Amazon Elastic Container Registry** será utilizado como registry privado de imagens Docker.

Imagens previstas:

```text
beyud-web
beyud-api
beyud-worker
```

Exemplo de versionamento futuro:

```text
beyud-web:<commit-sha>
beyud-api:<commit-sha>
beyud-worker:<commit-sha>
```

A estratégia de tag baseada no hash do commit ajuda a manter rastreabilidade entre código, pipeline, imagem e deploy.

---

## Argo CD

O **Argo CD** será responsável pela entrega contínua baseada em GitOps.

Responsabilidades previstas:

* monitorar o repositório Git;
* comparar o estado desejado com o estado atual do cluster;
* exibir diferenças;
* sincronizar alterações;
* permitir rollback;
* manter histórico de deploy.

Conceito principal:

```text
Git = estado desejado
Cluster = estado atual
Argo CD = reconciliador
```

---

## Observabilidade

A observabilidade da plataforma será baseada em:

* métricas;
* logs;
* dashboards;
* evidências operacionais.

Stack definida:

| Componente | Função                                |
| ---------- | ------------------------------------- |
| Prometheus | Coleta e armazenamento de métricas    |
| Grafana    | Visualização de métricas e dashboards |
| Loki       | Armazenamento e consulta de logs      |
| Promtail   | Coleta e envio de logs para o Loki    |

---

## Fluxo de métricas

```text
Aplicações e cluster
  -> métricas
  -> Prometheus
  -> Grafana
```

---

## Fluxo de logs

```text
Aplicações e cluster
  -> logs
  -> Promtail
  -> Loki
  -> Grafana
```

---

## Sinais observáveis previstos

### beyud-web

* disponibilidade da página;
* status de resposta;
* logs do container.

### beyud-api

* endpoint `/health`;
* tempo de resposta;
* quantidade de requisições;
* erros HTTP;
* falhas de conexão com banco;
* logs de requisições;
* logs de exceções.

### beyud-worker

* quantidade de contatos pendentes;
* quantidade de contatos processados;
* falhas de processamento;
* tempo de processamento;
* logs de execução;
* status do worker.

---

## Estrutura do repositório

```text
beyud-platform/
├── apps/
│   ├── web/
│   ├── api/
│   └── worker/
├── infra/
│   └── terraform/
├── k8s/
│   ├── base/
│   ├── overlays/
│   │   ├── dev/
│   │   └── prod-style/
│   └── argocd/
├── docs/
│   ├── architecture/
│   ├── decisions/
│   ├── runbooks/
│   ├── evidences/
│   └── linkedin/
├── .github/
│   └── workflows/
├── README.md
└── .gitignore
```

---

## Documentação

A documentação inicial está organizada em:

| Documento                            | Descrição                                           |
| ------------------------------------ | --------------------------------------------------- |
| `docs/architecture/overview.md`      | Visão geral da arquitetura                          |
| `docs/architecture/aws-network.md`   | Rede AWS, VPC, subnets, NAT, ALB e RDS              |
| `docs/architecture/kubernetes.md`    | Cluster RKE2, Rancher, Ingress e workloads          |
| `docs/architecture/cicd-gitops.md`   | GitHub Actions, ECR, Argo CD e fluxo GitOps         |
| `docs/architecture/observability.md` | Prometheus, Grafana, Loki e Promtail                |
| `docs/decisions/`                    | Decisões arquiteturais                              |
| `docs/runbooks/`                     | Procedimentos operacionais                          |
| `docs/evidences/`                    | Evidências técnicas e operacionais                  |
| `docs/linkedin/`                     | Conteúdos e publicações sobre a evolução do projeto |

---

## Decisões arquiteturais iniciais

As decisões arquiteturais da plataforma serão documentadas em `docs/decisions/`.

ADRs definidos inicialmente:

* `0001-use-monorepo.md`
* `0002-use-aws-as-cloud-provider.md`
* `0003-use-terraform-for-infrastructure-as-code.md`
* `0004-use-rke2-for-kubernetes.md`
* `0005-use-rancher-for-cluster-management.md`
* `0006-use-github-actions-and-argocd.md`
* `0007-use-postgresql-with-rds.md`
* `0008-use-prometheus-grafana-and-loki.md`
* `0009-use-private-subnets-for-core-components.md`
* `0010-use-prod-style-environment.md`

---

## Runbooks

A pasta `docs/runbooks/` será utilizada para documentar procedimentos operacionais.

Exemplos futuros:

* como verificar saúde da API;
* como consultar logs no Grafana/Loki;
* como verificar pods com erro;
* como validar sincronização do Argo CD;
* como investigar falhas de banco;
* como validar o processamento do worker.

---

## Evidências operacionais

A pasta `docs/evidences/` será utilizada para armazenar evidências da operação da plataforma.

Exemplos futuros:

* prints de dashboards;
* prints do Argo CD;
* prints do Rancher;
* saídas de comandos;
* testes de endpoint;
* evidências de deploy;
* evidências de troubleshooting.

---

## Etapas do projeto

Mapa-mestre de evolução:

1. Arquitetura e visão
2. Aplicação local
3. Containerização
4. Ambiente local integrado com Docker Compose
5. Terraform base da AWS
6. Compute e base operacional
7. Cluster Kubernetes
8. Deploy da aplicação no cluster
9. Observabilidade
10. Pipeline e GitOps
11. Evidências operacionais
12. Posicionamento profissional

---

## Princípios do projeto

A BEYUD Platform será construída seguindo os seguintes princípios:

* documentação antes da automação;
* arquitetura antes da implementação;
* infraestrutura versionada;
* separação por camadas;
* workloads em subnets privadas;
* entrada pública controlada por ALB e Ingress;
* banco de dados gerenciado;
* observabilidade desde as primeiras fases;
* decisões técnicas documentadas;
* evidências operacionais preservadas;
* evolução incremental e validada por etapas.

---

## Status atual

A fase atual do projeto é a construção da documentação base.

Etapas conceituais já definidas:

* Etapa 0.1 — Escopo funcional da aplicação;
* Etapa 0.2 — Estrutura do repositório e nomes oficiais;
* Etapa 0.3 — Arquitetura AWS e desenho lógico final;
* Etapa 0.4 — Diagrama oficial e explicação para entrevista;
* Etapa 0.4.1 — Diagrama AWS oficial;
* Etapa 0.5 — Decisões arquiteturais oficiais / ADRs;
* Etapa 0.6 — README inicial e documentação base.

---

## Status de implementação

| Área                     | Status        |
| ------------------------ | ------------- |
| Escopo funcional         | Definido      |
| Estrutura do repositório | Definida      |
| Arquitetura AWS          | Definida      |
| Diagrama AWS             | Definido      |
| ADRs iniciais            | Definidos     |
| Documentação base        | Em construção |
| Aplicação local          | Não iniciada  |
| Docker                   | Não iniciado  |
| Terraform                | Não iniciado  |
| Kubernetes               | Não iniciado  |
| CI/CD                    | Não iniciado  |
| GitOps                   | Não iniciado  |
| Observabilidade          | Não iniciada  |

---

## Resultado esperado

Ao final da construção da BEYUD Platform, o projeto deverá demonstrar:

* provisionamento de infraestrutura cloud com Terraform;
* execução de aplicações containerizadas;
* cluster Kubernetes RKE2 em ambiente AWS;
* gerenciamento via Rancher;
* deploy automatizado com GitHub Actions;
* entrega contínua com Argo CD;
* uso de registry privado com Amazon ECR;
* persistência em Amazon RDS PostgreSQL;
* entrada pública com Route 53, ACM e ALB;
* observabilidade com Prometheus, Grafana, Loki e Promtail;
* documentação técnica organizada;
* evidências operacionais para apresentação profissional.

---

## Autor

Projeto desenvolvido por **Ezequiel Bomfim**, com foco em Cloud, DevOps, Kubernetes, Platform Engineering, infraestrutura como código, observabilidade e operação em cloud.

```
```
