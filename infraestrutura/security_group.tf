resource "aws_security_group" "a290223-sc" {
    name = "${var.nome_instancia}-a290223-sc"
    description = "acesso 22"
    ingress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }
    egress{
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = [ "::/0" ]
        from_port = 0
        to_port = 0
        protocol = "-1"
    }
    tags = {
        Name = "a290223-sc"
    }
}