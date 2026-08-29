---
title: "Meu Primeiro Post"
date: 2026-08-29T18:24:21-03:00
slug: "meu-primeiro-post"
description: "Uma introdução e boas-vindas ao blog."
tags: []
authors:
  - name: "Samuel Roberto"
    link: "https://github.com/Bardo-programador"
---

## Início do Blog 
Estou publicando o meu primeiro post no meu novo blog. A inspiração para criar um blog foi do Fábio Akita no [https://akitaonrails.com/](https://akitaonrails.com/).
Acho o conteúdo dos artigos muito úteis e de bastante valor, então decidir criar um artigo para publicar meu conteúdo. Viso publicar tutorias, conteúdo técnico
o qualquer outra coisa que achar legal postar.


# Como criei este blog?

Para a criação do blog decidir usar o [Hugo](https://gohugo.io/) com o sistema de personalização do [Hextra](https://imfing.github.io/hextra/), especificamente usei o tema [re-Terminal](https://themes.gohugo.io/themes/hugo-theme-re-terminal/) com umas personalizações pro blog. Achei ele bem legal, então decidir usar ele.
Não vou dar muitos detalhes de como o Hugo funciona mais basicamente o conteúdo dos posts ficam em content/. Já layout/ trata da parte de estrutura e codificação das páginas.

Também criei uns scripts que até o momento auxiliam a criação de novos posts e atualiza a lista de posts de /blog e /. Eu planejo criar conteúdo em inglês também, quando crio um novo post ele já gera uma versão em inglês do posts (até o momento preciso traduzir na marra ou tradutor). No momento o CLI que criei tem essas funções.

```
❯ scripts/helper.sh                             
🛠️  CLI Helper do Blog - Bardo Programador

Uso:
  scripts/helper.sh <comando> [argumentos]

Comandos principais:
  new-post <título>      Cria um novo post (.md e .en.md) com data atual e chama regenerate_index
  regenerate_index       Recria/atualiza os arquivos _index.md de / e /blog e mapeia os posts

Outros utilitários:
  upload-s3 <imagem>     Faz upload de uma screenshot para o bucket S3/R2 (usado no Thunar)
  server                 Inicia o servidor local de desenvolvimento (hugo server -D)
  build                  Compila o site estático para produção (hugo --gc --minify)
  help, -h, --help       Exibe esta mensagem de ajuda

Exemplos:
  scripts/helper.sh new-post "Meu Novo Artigo Sobre Linux"
  scripts/helper.sh regenerate_index
  scripts/helper.sh upload-s3 ~/Imagens/print.png
```

## Screenshots para o Cloudflare R3
Para lidar com o envio de prints para o blog decidir usar o S4 da Cloudflare, o Cloudflare R2. Decidir usar ele porque consigo usar 10GB de armazenamento indefinidamente e para propósito do blog acredito ser mais que suficiente. Eu criei um script junto de um custom action no Thunar pra clicar com botão direito na imagem, enviar pro R2 e já copiar pro clipboard formatado em Markdown para usar o link, é muita praticidade.

## Deploy com Pages 
Pro deploy uso o Github Pages para hospedar o blog. A cada push na main o Action refaz o deploy e atualiza a página do blog.

# Estrutura 
A estrutura completa fica assim:
```
.
├── .github/workflows/pages.yaml   # Pipeline de CI/CD para GitHub Pages
├── content/                       # Conteúdo do blog em Markdown
│   ├── _index.md / _index.en.md   # Landing page (PT / EN)
│   ├── about.md / about.en.md     # Página Sobre (PT / EN)
│   └── blog/                      # Posts organizados por data (YYYY/MM/DD/)
├── layouts/                       # Sobrescritas de templates e shortcodes
│   ├── _default/baseof.html       # Estrutura base com rodapé em largura total
│   ├── blog/list.html             # Listagem limpa em h5 agrupada por mês
│   ├── partials/                  # Cabeçalho, menu e seletor de idiomas
│   └── shortcodes/s3img.html      # Shortcode para imagens hospedadas no S3/R2
├── scripts/                       # CLI Helpers e automações locais
│   ├── helper.sh                  # Wrapper principal de comandos
│   ├── new_post.py                # Gerador automático de posts
│   ├── regenerate_index.py        # Validador e regenerador de índices
│   └── upload_s3.sh               # Upload de screenshots para S3 (CLI & Thunar)
├── static/                        # Recursos estáticos e customizações CSS
│   ├── style.css                  # Customizações de estilo (fonte 150%, rodapé)
│   └── styles.css                 # Folha de estilo base do tema
└── hugo.yaml                      # Configuração central do site
```

O restante do projeto está no [Meu repositório](https://github.com/Bardo-programador/bardo-programador.github.io). Se tiver alguma sugestão, crítica ou só quiser falar comigo só subir um Issue ou mandar mensagem no meu [Linkedin](https://www.linkedin.com/in/samuel-roberto-635666229/).
