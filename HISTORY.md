# Histórico de Desenvolvimento

## 21 de Fevereiro de 2024

- Implementação da infraestrutura na AWS utilizando containers para a aplicação Flask.
- Criada uma arquitetura de duas tiers, com uma camada de acesso público e outra privada.

## 22 de Fevereiro de 2024

- Configuração de uma VPC com quatro sub-redes: duas públicas e duas privadas.
- Sub-redes públicas configuradas com rota padrão para o Internet Gateway da VPC.
- Sub-redes privadas configuradas com rota padrão para o NAT Gateway, restringindo o acesso direto à internet.
- Desenvolvimento do módulo Network no Terraform para facilitar a implantação da infraestrutura.

## 23 de Fevereiro de 2024

- Inicialmente planejado o uso do ECS (Elastic Container Service) para containerização da aplicação.
- Problemas encontrados com a verificação da saúde da aplicação pelo target group do ECS, resultando em tarefas pendentes indefinidamente.
- Decisão de migrar para o EKS (Elastic Kubernetes Service) para uma solução mais robusta.
- Implantação do cluster do EKS utilizando Terraform, incluindo a criação de node groups para funcionar como worker nodes.

## 25 de Fevereiro de 2024

- Testes e resolução de falhas na configuração do cluster do EKS.
- Necessidade de automatizar o processo de implantação da aplicação em containers.
- Criação do chart de deploy da aplicação para kuberbernetes
- Clone aws-load-balancer-controler para que possa o ingress da aplicação crir um ELB e possa ser alcançado fora da VPC.
- Alterações no chart aws-load-balancer-controler necessárias para uso em nosso ambiente.

## 26 de Fevereiro de 2024

-+++++++++++++++++++++++++++++++++++++*
- instalação do cert-manager necessário para o aws-load-balancer-controller funcionar
- Instalação do chart aws-load-balancer 
- Instalação do chart de deploy da aplicação
- teste da aplicação através do dns do load balancer.

## Logs dos testes
OBS. : Todo o processo de teste como forma de mostrar os comandos executados estão no arquivo "testes-na-aplicação"


## O que eu faria se eu tivesse mais tempo devido estar muito atarefado nesta semana e ter ido participar de evento da empresa em que trabalho atualmente em outra cidade:

Eu testei o Prometheus junto com o grafana para observabilidade da aplicação mas embora eu tenha achado como instalar eu precisava criar a metrica a ser exportada dentro da aplicação flask e como eu iria fazer para ler a mesma no prometheus e decedi por não usar mais tempo para solução desta questão

Eu criaria o step de instalação dos chart do Helm no Github actions o qual eu fiz algumas tentativas mas estava tendo problemas de autenticação que optei por não usar mais tempo resolvendo essa questão para que eu conseguisse fazer a entrega do desafio.


## Solução que eu pensei em fazer mas escolhi em utilizar solução diferente:

Eu iria utilizar a mesma infraestrutura criada porém ao invés de EKS eu pensei em usar o ECS oo que iria simplificar a infra estrutura. Não foi para frente pois após a criação da infra estrutura estava acontecendo de a task não conseguir acesso ao ECR mesmo tendo todas as permissões necessárias para fazer download da imagem no ECR. Por conta deste problema estava demorando a resolver e para não perder mais tempo eu resolvi criar a aplicação no EKS po eu ter mais controle de come seria a criação do recurso porém com maior complexidade.
O erro de autenticação eu fui entender quando crirei o eks e estava sofrendo o mesmo erro e ate que entendi que o erro de autenticação era gerado por conta de o recurso ter sido criado vindo do github com autenticação OIDC o que obrigava as roles que precisam se autenticar no EKS tivesse o trust relationship com premissõs de sts.assume.role para o OIDC ID do EKS e seria da mesma maneira a resolução utilizando o ECS mas decidi ainda assim continuar com a solução do EKS.

Mesmo sendo uma aplicação simples eu tive uma idéia de criar um banco de dados postgress em um outro pod para que a aplicação enviasse os comentários inseridos guardados in memory para o postgres e sendo assim mesmo que a aplicação terminasse por algum motivo os dados ainda estariam persistentes no postgres.