module "aws-prod1" {
    source = "../../infraestrutura"
    instancia = "t3.medium"
    nome_instancia = "terraformProd"
    regiao_aws = "us-west-2"
    chave = "iac-prod2"   
}