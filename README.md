# Infraestrutura como Código (IaC) com Terraform

Este projeto utiliza o Terraform para criar e gerenciar a infraestrutura de um cluster Kubernetes na AWS. A seguir, está descrita a infraestrutura que é criada pelos arquivos Terraform.

## Recursos Criados

* **Cluster Kubernetes**: um cluster Kubernetes chamado `snack-tech` é criado na região `us-east-1` da AWS.
* **Security Group**: um security group chamado `SG-snacktech` é criado para controlar o tráfego de rede para o cluster.
* **ECR**: dois repositórios ECR são criados para armazenar imagens Docker: `ecr-snacktech` e `ecr-snacktech-authorizer`.
* **VPC**: é usada a subnet padrão já criada na conta do usuário seu CIDR é `172.31.0.0/16`.
* **Subnets**: várias subnets são agrupadas num pool para acomodar os nós do cluster.
* **Nós do Cluster**: um grupo de nós chamado `NG-snacktech` é criado com 2 instâncias `t3a.micro` cada. Uma configuração de escalabilidade varia esse número até 5, conforme necessidade.

## Arquivos Terraform

Os seguintes arquivos Terraform são utilizados para criar a infraestrutura:

* [src/backend.tf](src/backend.tf): define o backend do Terraform para armazenar o estado da infraestrutura. A especificação do backend é vazia para exigir que ela seja passada como parametro do comando init.
* [src/eks-cluster.tf](src/eks-cluster.tf): cria o cluster Kubernetes e define sua configuração.
* [src/eks-nodeg.tf](src/eks-nodeg.tf): cria o grupo de nós do cluster.
* [src/sg.tf](src/sg.tf): cria o security group para o cluster.
* [src/ecr.tf](src/ecr.tf): cria os repositórios ECR.
* [src/data.tf](src/data.tf): define os dados necessários para criar a infraestrutura.
* [src/vars.tf](src/vars.tf): define as variáveis utilizadas nos arquivos Terraform.



### Tutorial de Implantação do Cluster Kubernetes com Terraform

Este tutorial mostra o passo a passo para criar um cluster Kubernetes na AWS e configurar os nós necessários para a aplicação.

---

### **1. Criar o Cluster e os Nós com o Terraform (`snacktech-infra-k8s`)**

#### **a) Inicializar o Terraform**
Inicie o Terraform no diretório do projeto para baixar os provedores e configurar o backend remoto, se necessário.

```bash
terraform init
```

#### **b) Validar a Configuração**
Verifique se há erros na configuração do Terraform.

```bash
terraform validate
```

#### **c) Gerar o Plano de Execução**
Antes de aplicar as mudanças, gere um plano detalhado para visualizar o que será criado ou modificado.

```bash
terraform plan -out=tfplan
```

#### **d) Visualizar o Plano de Execução**
Exiba o conteúdo do plano gerado.

```bash
terraform show tfplan
```

#### **e) Aplicar o Plano**
Provisione os recursos na AWS. Confirme a execução ou use a flag `-auto-approve` para pular a confirmação.

```bash
terraform apply tfplan
```

#### **f) Verificar a Criação do Cluster**
Após a execução do Terraform, verifique se o cluster foi criado corretamente com o comando:

```bash
aws eks describe-cluster --name snack-tech --region us-east-1
```

#### **g) Configurar o Acesso ao Cluster com `kubectl`**
Atualize a configuração do Kubernetes para acessar o cluster criado.

```bash
aws eks update-kubeconfig --name snack-tech --region us-east-1
```

#### **h) Verificar os Nós**
Verifique se os nós do cluster estão ativos.

```bash
kubectl get nodes