#### Exemplo básico de IaC utilizando o Terraform.
#### Provisionamento: Auto Scaling group e ELB na AWS.

```
docker pull locustio/locust:latest
docker run -p 8089:8089 -d -v $PWD:/home/terraformAutoScaling \
locustio/locust:latest -f /home/terraformAutoScaling/locustfile.py
```