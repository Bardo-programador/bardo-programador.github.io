# 💻 Bardo Programador (Blog Pessoal)

[![Deploy Hugo site to Pages](https://github.com/Bardo-programador/bardo.github.io/actions/workflows/pages.yaml/badge.svg)](https://github.com/Bardo-programador/bardo.github.io/actions/workflows/pages.yaml)

Repositório do meu blog pessoal e diário de anotações sobre desenvolvimento de software, Linux, arquitetura e tecnologia.

Construído utilizando o gerador de sites estáticos [Hugo](https://gohugo.io/), tema [re-Terminal](https://github.com/mirus-ua/hugo-theme-re-terminal) com estética retrô duotone, suporte nativo a posts internacionais (PT/EN), hospedagem de screenshots em bucket S3/R2 e deploy automático no GitHub Pages.

---

## 📂 Estrutura do Projeto

```text
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

---

## ⚡ Guia Rápido de Comandos (CLI Helper)

O repositório inclui um utilitário de terminal em `scripts/helper.sh` para facilitar as tarefas do dia a dia:

### 1. Criar um novo post
```bash
./scripts/helper.sh new-post "Título do Artigo"
```
> Cria automaticamente os arquivos `.md` (PT) e `.en.md` (EN) em `content/blog/YYYY/MM/DD/` com o timestamp atual, slug sanitizado, frontmatter pré-preenchido e regenera os índices do blog.

### 2. Regenerar e validar os índices
```bash
./scripts/helper.sh regenerate_index
```
> Varre todos os posts, valida a estrutura e atualiza os arquivos `_index.md` de `/` e `/blog`.

### 3. Rodar o ambiente local de desenvolvimento
```bash
./scripts/helper.sh server
# ou
hugo server -D
```
* 🇧🇷 **Português**: [http://localhost:1313/](http://localhost:1313/)
* 🇺🇸 **Inglês**: [http://localhost:1313/en/](http://localhost:1313/en/)
* 📚 **Arquivo do Blog**: [http://localhost:1313/blog/](http://localhost:1313/blog/)

### 4. Compilar para produção
```bash
./scripts/helper.sh build
# ou
hugo --cleanDestinationDir --gc --minify
```

---

## ✍️ Convenções de Posts e Frontmatter

Os posts seguem a estrutura de pastas por data `content/blog/YYYY/MM/DD/slug.md` e URLs padronizadas no formato `/blog/:year/:month/:day/:slug/`.

### Exemplo de Frontmatter (`slug.md`):
```yaml
---
title: "Anotações e Produtividade no Terminal Linux"
date: 2026-08-28T21:45:00-03:00
slug: "anotacoes-linux"
description: "Dicas de atalhos e ferramentas de linha de comando para o dia a dia."
tags: ["linux", "terminal", "produtividade"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Conteúdo do artigo em Markdown aqui...
```

* **Descrição**: Usada nos cards e listagens da Home (recomendado de 100 a 160 caracteres).
* **Internacionalização**: Para disponibilizar o artigo em inglês, basta manter o arquivo irmão `slug.en.md` no mesmo diretório. O seletor de idiomas no topo da página faz a alternância direta entre as versões do artigo.

---

## 🖼️ Upload de Imagens no S3 / Cloudflare R2

Para evitar commits de arquivos binários pesados no Git:

1. **Configuração**: Credenciais em `scripts/.env` (não versionado no Git).
2. **Via Thunar (1 Clique no Linux)**:
   * Clique direito em qualquer imagem > **`Enviar Imagem para S3 (Blog)`**.
   * O script faz o upload, envia notificação no desktop (`notify-send`) e copia a tag Markdown (`![alt](url)`) para a Área de Transferência (`wl-copy`).
3. **Via CLI**:
   ```bash
   ./scripts/helper.sh upload-s3 ~/Imagens/screenshot.png
   ```
4. **Shortcode Opcional**:
   ```markdown
   {{< s3img src="screenshots/2026/08/exemplo.png" alt="Demonstração" caption="Legenda" >}}
   ```

> [!NOTE] 
> O arquivo `scripts/.env` guarda suas configurações do S3/R2:

> [!WARNING]
> Jamais versione seu script/.env 
---

## 🚀 Deploy Contínuo (GitHub Pages)

O deploy é realizado de forma 100% automatizada via GitHub Actions ([`.github/workflows/pages.yaml`](.github/workflows/pages.yaml)):

```bash
git add .
git commit -m "feat: novo artigo publicado"
git push origin main
```

O workflow compila o site com Hugo Extended e publica diretamente em:
👉 **[https://bardo-programador.github.io/](https://bardo-programador.github.io/)**

---

## 📄 Licença

Conteúdo e código sob licença [MIT](LICENSE).
