# Hardening Container

## Estrutura inicial

O projeto possui a seguinte estrutura:

```text
projeto/
├── app/
├── docs/
├── Dockerfile
└── docker-compose.yml
```

---

## Cenário

Uma empresa possui uma aplicação web executada em containers Docker. A aplicação funciona corretamente em ambiente de desenvolvimento, porém uma auditoria de segurança identificou que sua configuração não atende aos requisitos mínimos para execução em produção.

A equipe de DevSecOps foi responsável por realizar o hardening do ambiente.

O objetivo é reduzir a superfície de ataque, aplicar o princípio do menor privilégio, proteger informações sensíveis, controlar o consumo de recursos e reduzir a exposição desnecessária dos serviços.

Após as alterações, a aplicação deverá continuar funcionando normalmente.