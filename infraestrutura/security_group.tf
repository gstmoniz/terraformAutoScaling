resource "aws_security_group" "a290223-sc" {
    name = "${var.nome_instancia}-a290223-sc"
    description = "acesso 22 8080"
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

resource "aws_security_group_rule" "app-node" {
    security_group_id = aws_security_group.a290223-sc.id 
    description = "gstmoniz/app-node:1.4"
    type = "ingress"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
}