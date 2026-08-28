# 📖 Guia Completo do Blog Pessoal (Bardo Programador)

Este documento contém todas as instruções práticas para criar conteúdo, configurar o upload de screenshots via Thunar e realizar o deploy no GitHub Pages.

---

## 🚀 1. Executando o Blog Localmente

Para iniciar o servidor local com recarregamento em tempo real (Live Reload):

```bash
# Iniciar o servidor local (incluindo rascunhos)
hugo server -D
```

Acesse no navegador:
* 🇧🇷 **Português (Padrão)**: [http://localhost:1313/](http://localhost:1313/)
* 🇺🇸 **Inglês (Internacional)**: [http://localhost:1313/en/](http://localhost:1313/en/)

Para testar a compilação final dos arquivos estáticos:
```bash
hugo --cleanDestinationDir --gc --minify
```

---

## ✍️ 2. Como Criar Novos Posts

### 2.1 Estrutura de Pastas por Data (Ano/Mês/Dia)
Recomendamos criar os arquivos dentro da pasta do ano/mês/dia correspondente:

```text
content/
└── blog/
    ├── _index.md            # Índice da seção do blog (PT)
    ├── _index.en.md         # Índice da seção do blog (EN)
    └── 2026/
        └── 08/
            └── 27/
                ├── meu-post.md     # Versão em Português
                └── meu-post.en.md  # Versão internacional em Inglês
```

### 2.2 Exemplo de Post em Português (`meu-post.md`)
```yaml
---
title: "Meu Post de Exemplo"
date: 2026-08-27T20:00:00-03:00
slug: "meu-post-de-exemplo"
description: "Breve resumo do post para listagem e SEO."
tags: ["linux", "desenvolvimento", "produtividade"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Seu conteúdo em Markdown aqui...
```

### 2.3 Exemplo de Post Internacional em Inglês (`meu-post.en.md`)
```yaml
---
title: "My Example Post"
date: 2026-08-27T20:00:00-03:00
slug: "meu-post-de-exemplo"
description: "Short summary of the post for listing and SEO."
tags: ["linux", "development", "productivity"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Your content in English here...
```

> **💡 Dica de Permalinks:** O blog está configurado para gerar URLs automáticas no formato `/blog/:year/:month/:day/:slug/`.
> A versão em português ficará em `/blog/2026/08/27/meu-post-de-exemplo/` e a versão em inglês em `/en/blog/2026/08/27/meu-post-de-exemplo/`.
> O seletor de idiomas no menu superior alternará automaticamente entre eles.

---

## 🖼️ 3. Upload de Screenshots no S3/R2 com Thunar Custom Actions

Para não comitar imagens pesadas no Git, você pode clicar com o botão direito em qualquer imagem no gerenciador de arquivos **Thunar** e enviá-la para o S3 em 1 clique.

### 3.1 Configuração Inicial das Credenciais do S3
1. Crie o arquivo `.env` a partir do modelo:
   ```bash
   cp scripts/.env.example scripts/.env
   ```
2. Edite o arquivo `scripts/.env` com as informações do seu bucket S3:
   ```bash
   S3_BUCKET_NAME="seu-bucket-de-screenshots"
   AWS_REGION="auto"
   S3_FOLDER_PREFIX="screenshots"
   
   # Opcional (se usar CDN / CloudFront ou Cloudflare R2):
   # S3_BASE_URL="https://cdn.meusite.com"
   # S3_ENDPOINT_URL="https://<account_id>.r2.cloudflarestorage.com"
   ```

*(Se o seu `aws-cli` já estiver configurado via `aws configure`, as credenciais serão lidas automaticamente).*

### 3.2 Como Configurar a Ação no Thunar (Passo a Passo)

1. Abra o gerenciador de arquivos **Thunar**.
2. No menu superior, clique em **Editar** -> **Configurar ações personalizadas...** (`Configure custom actions...`).
3. Clique no botão **`+`** (Adicionar nova ação).
4. Preencha a aba **Básico**:
   * **Nome**: `Enviar Imagem para S3 (Blog)`
   * **Descrição**: `Faz upload para o S3 e copia o link Markdown para a Área de Transferência`
   * **Comando**:
     ```bash
     /home/samuel/git/bardo.github.io/scripts/upload_s3.sh %f
     ```
   * **Ícone**: Clique no botão de ícone e selecione um ícone de sua preferência (ex: `image-x-generic`, `document-send` ou `cloud-upload`).
5. Na aba **Condições de aparecimento**:
   * **Padrão de arquivo**: `*` ou `*.png;*.jpg;*.jpeg;*.gif;*.webp;*.svg`
   * Marque a caixa de seleção: **Arquivos de imagem**.
6. Clique em **OK** e feche a janela de configuração.

### 3.3 Como Usar no Dia a Dia

1. Tire uma captura de tela (screenshot) ou baixe uma imagem.
2. Localize a imagem no Thunar, clique com o **botão direito** nela e selecione:
   👉 **`Enviar Imagem para S3 (Blog)`**.
3. O script fará o upload imediatamente para o S3/R2, disparará uma notificação no desktop via `notify-send` e colocará o código Markdown na sua Área de Transferência (`wl-copy`).
4. Abra o seu post no editor e simplesmente dê **`Ctrl + V`**!

---

## 🏷️ 4. Formas de Incluir Imagens nos Posts

### Opção 1: Markdown Direto (Copiado pelo Thunar)
```markdown
![descricao da imagem](https://pub-xxxxxxxxxxxxxx.r2.dev/screenshots/2026/08/2026-08-27-screenshot.png)
```

### Opção 2: Shortcode Hugo `s3img` (Flexível e Responsivo)
Se você configurou `params.s3_base_url` no `hugo.yaml`, pode usar o shortcode passando apenas a chave relativa:

```markdown
{{< s3img src="screenshots/2026/08/2026-08-27-screenshot.png" alt="Tela de exemplo" caption="Legenda opcional centralizada" >}}
```

Parâmetros suportados no shortcode:
* `src`: Caminho relativo ou URL completa da imagem.
* `alt`: Texto alternativo de acessibilidade.
* `caption`: Legenda exibida abaixo da imagem.
* `class`: Classes CSS adicionais.
* `width` e `height`: Dimensões opcionais.

---

## 🌐 5. Deploy no GitHub Pages

O projeto já possui a automação configurada via GitHub Actions em [`.github/workflows/pages.yaml`](.github/workflows/pages.yaml).

### 5.1 Ativação do GitHub Pages no Repositório
1. Acesse o seu repositório no GitHub: `https://github.com/Bardo-programador/bardo.github.io`
2. Vá na aba **Settings** (Configurações).
3. No menu lateral esquerdo, clique em **Pages**.
4. Em **Build and deployment** > **Source**, selecione **GitHub Actions**.

### 5.2 Publicando Alterações
Toda vez que você fizer um commit e push para a branch `main`:
```bash
git add .
git commit -m "feat: novo post sobre desenvolvimento"
git push origin main
```
O GitHub Actions irá compilar automaticamente o site com Hugo Extended e publicá-lo em:
👉 **`https://bardo-programador.github.io/`**

---

## ⚙️ 6. Estrutura de Arquivos do Projeto

```text
.
├── .github/workflows/pages.yaml   # CI/CD para GitHub Pages
├── assets/                        # Recursos compilados e CSS customizado
├── content/                       # Conteúdo do blog (PT e EN)
│   ├── _index.md / _index.en.md   # Landing page
│   ├── about.md / about.en.md     # Página Sobre
│   └── blog/                      # Seção do blog com posts por data
│       └── 2026/08/27/
├── i18n/                          # Dicionários de tradução (pt.yaml, en.yaml)
├── layouts/shortcodes/            # Shortcodes personalizados (s3img.html)
├── scripts/                       # Scripts de automação (upload_s3.sh, .env)
├── GUIA_BLOG.md                   # Este manual de instruções
├── hugo.yaml                      # Configuração central do blog
└── README.md                      # (Intacto, conforme solicitado)
```
