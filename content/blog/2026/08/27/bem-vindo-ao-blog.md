---
title: "Bem-vindo ao meu novo Blog Pessoal"
date: 2026-08-27T20:00:00-03:00
slug: "bem-vindo-ao-blog"
description: "Apresentação da nova estrutura do blog, suporte a posts internacionais e fluxo com S3."
tags: ["blog", "hugo", "hextra", "linux"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Seja bem-vindo ao meu blog pessoal! 🚀

Este espaço foi construído utilizando o gerador de sites estáticos [Hugo](https://gohugo.io/) e o tema [Hextra](https://imfing.github.io/hextra), oferecendo excelente performance, modo escuro nativo e suporte a internacionalização.

---

## O que você encontrará por aqui?

1. **Desenvolvimento e Código**: Estudos sobre arquitetura de software, APIs e boas práticas.
2. **Ambiente Linux e Automações**: Dicas de terminal, customizações e produtividade.
3. **Posts Internacionais**: Artigos técnicos em Português e Inglês para alcance global.

---

## Exemplo de Código

Aqui está um trecho de exemplo em Shell:

```bash
# Executando o servidor local do blog
hugo server -D

# Enviando uma screenshot diretamente para o S3
./scripts/upload_s3.sh ~/Imagens/minha-screenshot.png
```

---

## Hospedagem de Screenshots no S3

Para manter o repositório leve e rápido, os screenshots e imagens são enviados diretamente para um bucket S3.

Podemos incluir imagens usando sintaxe Markdown tradicional ou através do nosso shortcode personalizado:

```markdown
{{</* s3img src="screenshots/2026/08/exemplo.png" alt="Demonstração" caption="Captura de tela enviada para o S3" */>}}
```

Fique à vontade para explorar os outros posts e trocar o idioma no topo da página!
