module "aws-prod1" {
    source = "../../infraestrutura"
    instancia = "t3.medium"
    nome_instancia = "terraformProd"
    regiao_aws = "us-west-2"
    chave = "iac-prod2"
    min_ec2 = 2
    max_ec2 = 8
    lb_target = "prodTargetASGroup"
    desenv = false
}