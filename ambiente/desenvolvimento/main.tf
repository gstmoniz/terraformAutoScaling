module "aws-dev1" {
    source = "../../infraestrutura"
    instancia = "t2.micro"
    nome_instancia = "terraformDev"
    regiao_aws = "us-west-2"
    chave = "iac-dev2"   
}