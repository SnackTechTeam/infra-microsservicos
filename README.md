# Snacktech Infraestrutura de microsserviços  
Este projeto utiliza o Terraform para criar e gerenciar a infraestrutura de microsserviços para o sistema Snacktech.
Este sistema foi desenvolvido como parte do processo de avaliação da quarta fase do curso de pósgraduação em Arquitetura de Software da FIAP.
Segue abaixo video descritivo da entrega dessa fase.
#### [Video de apresentação Fase 4](https://www.youtube.com/) 

## Descrição geral da arquitetura do sistema Snacktech
Os serviços hospedados na estrutura criada por eles são uma refatoração do projeto original [Snacktech](https://github.com/SnackTechTeam/SnackTech). Nele pode ser obtida a descrição dos requisitos do sistema. 

Para essa fase, a aplicação original foi refatorada e dividida em 3 microsserviços.

### Microsserviço Produtos
Aplicação responsável por administrar e fornecer as informações dos produtos. Ela é composta por uma WebApi .NET e um banco de dados RDS Microsoft Sql Server.
Repositório: [snacktech-api-products](https://github.com/SnackTechTeam/snacktech-api-products)

### Microsserviço Pedidos
Aplicação responsável por administrar e fornecer as informações de Cliente e Pedidos. Ela é composta por uma WebApi .NET, um Worker e um banco de dados RDS Microsoft Sql Server. O Worker aqui cumpre a tarefa de receber de forma assincrona a confirmação do pagamento dos pedidos. 
Repositório API: [snacktech-api-orders](https://github.com/SnackTechTeam/snacktech-api-orders)
Repositório Worker: [snacktech-worker-payment](https://github.com/SnackTechTeam/snacktech-worker-payment)

### Microsserviço Pagamento
Aplicação responsável por intermediar o contato com a operadora dos pagamentos, para este projeto essa operadora é o Mercado Pago. Ela é composta por uma WebApi e um banco de dados MongoDB hospedado no serviço Atlas.
Repositório: [snacktech-api-payment](https://github.com/SnackTechTeam/snacktech-api-payment)

### Descrição simplificada de uma trilha do sistema
O fluxo abaixo serve para dar uma idéia geral da arquitetura de informação dentro do sistema. Vamos descrever um processo que começa com o cadastramento de um produto, depois do cliente, criação do pedido e evolução deste pedido até sua finalização.

1. Efetuar Post no endpoint api/Produtos da API de produtos com os dados do novo produto. Esse produto agora pode ser consultado por Id ou por sua categoria.
2. Efetuar Post no endpoint api/Clientes da API de pedidos com os dados no novo cliente.
3. Efetuar Post no endpoint api/Pedidos da API de pedidos com o CPF do cliente cadastrado anteriormente.
4. Efetuar Put no endpoint api/Pedidos da API de pedidos com o ID do pedido e a lista de itens (produtos).
5. Efetuar Patch no endpoint api/finalizar-para-pagamento/{idPedido} para enviar esse pedido para pagamento.
    - Internamente a Api de Pedidos vai efetuar Post para endpoint api/Pagamentos/finalizacao com os dados do pedido.
    - A Api de pagamentos vai efetuar chamada ao serviço da operadora de pagamentos, a qual vai retornar o QR Code para pagamento do pedido.
    - A Api de pagamentos vai retornar um QrCode que servirá para efetuar o pagamento.
    - A Api de pedidos recebe o QrCode e o encaminha como resposta da chamada original.
6. Após o pagamento do QrCode, a operadora de pagamento aciona nossa Api de Pagamento por meio do endpoint de webhook desta API.
7. De posse da confirmação de pagamento, a API de pagamento registra a confirmação de pagamento recebida e envia para fila SQS uma confirmação do pagamento do pedido.
8. O Worker Pagamento (que pertence ao serviço de pedidos) recebe essa mensagem e efetua a atualização do pedido para a situação "Recebido" (que aqui no sistema significa pago e aguardando preparo).
9. Após o pagamento o pedido fica disponível para ser evoluido para as fazer seguintes.
10. Efetuar Patch para endpoint api/Pedidos/iniciar-preparacao/{idPedido} da Api de pedidos. Isso informa que o pedido teve seu preparo inicial.
11. Efetuar Patch para endpoint api/Pedidos/concluir-preparacao/{idPedido} da Api de pedidos. Isso informa que o pedido teve seu preparo concluido e está disponível para retirada.
12. Efetuar Patch para endpoint api/Pedidos/finalizar/{idPedido} da Api de pedidos. Isso informa que o pedido foi entregue e finalizado.

## Descrição geral da infraestrutura

### Recursos Criados

* **Cluster Kubernetes**: um cluster Kubernetes chamado `snacktech-infra` é criado na região `us-east-1` da AWS.
* **Security Group**: um security group chamado `SG-snacktech-infra` é criado para controlar o tráfego de rede para o cluster.
* **ECR**: criar os repositórios ECR usados pelas aplicações dos microsserviços.
* **VPC**: é usada a subnet padrão já criada na conta do usuário seu CIDR é `172.31.0.0/16`.
* **Subnets**: várias subnets são agrupadas num pool para acomodar os nós do cluster.
* **Nós do Cluster**: um grupo de nós chamado `NG-snacktech-infra` é criado com 2 instâncias `t3a.medium` cada. Uma configuração de escalabilidade varia esse número até 5, conforme necessidade. 
* **Filas SQS**: são criadas duas filas sendo uma a fila principal para conclusão de pagamentos e uma fila adicional para implementar o padrão DLQ (Dead Letter Queue).
* **Bancos de dados RDS**: São criados dois bancos de dados RDS para suporte aos serviços de produtos e pedidos.

### Arquivos Terraform

Esses são os principais manifestos Terraform utilizados para criar a infraestrutura:

* [backend.tf](src/backend.tf): define o backend do Terraform para armazenar o estado da infraestrutura. A especificação do backend é vazia para exigir que ela seja passada como parametro do comando init.
* [eks-cluster.tf](src/eks-cluster.tf): cria o cluster Kubernetes e define sua configuração.
* [eks-nodeg.tf](src/eks-nodeg.tf): cria o grupo de nós do cluster.
* [sg.tf](src/sg.tf): cria o security group para o cluster.
* [ecr.tf](src/ecr.tf): cria os repositórios ECR.
* [db-pedidos-instance.tf](src/db-pedidos-instance.tf): cria o banco RDS para o serviço de pedidos.
* [db-produtos-instance.tf](src/db-produtos-instance.tf): cria o banco RDS para o serviç0 de produtos.
* [data.tf](src/data.tf): define os dados necessários para criar a infraestrutura.
* [vars.tf](src/vars.tf): define as variáveis utilizadas nos arquivos Terraform.
* [sqs-pagamentos.tf](src/sqs-pagamentos.tf): define as filas SQS usadas para comunicação entre os serviços de pagamentos e pedidos.


### Tutorial de Implantação através de execução local do terraform

Este tutorial mostra o passo a passo para criar um cluster Kubernetes na AWS e configurar, necessário possuir as aplicações terraform, aws e kubectl instaladas e configuradas.

---

#### **1. Criar o Cluster e os Nós com o Terraform**

**a) Inicializar o Terraform**
Inicie o Terraform no diretório do projeto para baixar os provedores e configurar o backend remoto. O parametro "bucket" do comando abaixo deve ser substituido pelo nome de um bucket previamente criado no S3 da sua conta.

```bash
terraform init -backend-config="bucket=snacktech-tfstate" -backend-config="key=microsservices/terraform.tfstate" -backend-config="region=us-east-1"

```

**b) Validar a Configuração**
Verifique se há erros na configuração do Terraform.

```bash
terraform validate
```

**c) Gerar o Plano de Execução**
Antes de aplicar as mudanças, gere um plano detalhado para visualizar o que será criado ou modificado. Neste comando substituia NNNNNNNNNNNN pelo valor de um role-id válido. Esse id pode se obtido na página do IAM, dentro do role voclabs da conta LAB da AWS Academy.

```bash
terraform plan -out=tfplan -var accountIdVoclabs=NNNNNNNNNNNN
```

**d) Visualizar o Plano de Execução**
Exiba o conteúdo do plano gerado.

```bash
terraform show tfplan
```

**e) Aplicar o Plano**
Provisione os recursos na AWS. Confirme a execução ou use a flag `-auto-approve` para pular a confirmação.

```bash
terraform apply tfplan
```

**f) Verificar a Criação do Cluster**
Após a execução do Terraform, verifique se o cluster foi criado corretamente com o comando:

```bash
aws eks describe-cluster --name snacktech-infra --region us-east-1
```

**g) Configurar o Acesso ao Cluster com `kubectl`**
Atualize a configuração do Kubernetes para acessar o cluster criado.

```bash
aws eks update-kubeconfig --name snacktech-infra --region us-east-1
```

**h) Verificar os Nós**
Verifique se os nós do cluster estão ativos.

```bash
kubectl get nodes
```
**h) Destruir a infra criada**
- Apague manualmente todas as imagens armazenadas dentro dos ECRs
- Rode o comando abaixo com o mesmo numero de role-id usado no comando plan

```bash
terraform destroy -var accountIdVoclabs=NNNNNNNNNNNNN
```

#### **2. Ajustar configuração do pipeline para deploy usando Github Action**
O procedimento abaixo diz respeito a atualização de variables e secrets do Team. Não sobrescreva os valores incluidos no Team através de parametros especificos do repositório, isso vai causar problemas durante um deploy conjunto. 

**a) Ajustar credenciais AWS**
A cada nova execução do pipeline os valores das credenciais devem ser atualizados. Esses valores devem ser incluídos noos secrets de nome:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SECRET_ACCESS_TOKEN
- AWS_ACCOUNT_ID_VOCLABS (número do role-id do voclabs, obtido na página do IAM)

**b) Ajustar bucket do tf-state**
Sempre que ocorrer troca da conta destino do deploy trocar o valor da variável **BACKEND_BUCKET_NAME**, o valor deve corresponder a um bucket S3 previamente criado na conta do deploy.

**c) Ajustar parametros de banco de dados**
A troca da conta destino do deploy, vai gerar instancias de banco de dados com endereços diferentes. Ou seja, após o deploy atualize manualmente os secrets que contém CONNECTION_STRING.

## CI/CD

Este repositório possui um pipeline configurado para executar análise de vulnerabilidades com Sonarqube e o deploy da infraestrutura. 
Como resultado de um PR aprovado para a branch main, é desencadeado o processo de deploy para uma conta AWS previamente configurada nas variáveis de ambiente.