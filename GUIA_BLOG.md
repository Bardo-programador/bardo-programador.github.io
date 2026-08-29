# 📖 Guia Completo do Blog Pessoal (Bardo Programador)

Este documento contém todas as instruções práticas para criar conteúdo usando a CLI, configurar o upload de screenshots via Thunar e realizar o deploy no GitHub Pages.

---

## 🛠️ 1. Usando a CLI Helper do Blog (`helper.sh`)

Criamos um utilitário de linha de comando para automatizar a criação de posts, regeneração de índices e execução de tarefas:

```bash
# Ver a ajuda e comandos disponíveis
./scripts/helper.sh
```

### Comandos principais:
* **Criar um novo post automaticamente:**
  ```bash
  ./scripts/helper.sh new-post "Meu Novo Artigo Sobre Linux"
  ```
  *(Cria o arquivo `.md` e `.en.md` com slug, front matter e data/hora atual em `content/blog/YYYY/MM/DD/` e chama automaticamente a regeneração de índices).*

* **Regenerar e validar índices:**
  ```bash
  ./scripts/helper.sh regenerate_index
  ```
  *(Mapeia todas as postagens, valida e atualiza os arquivos `_index.md` de `/` e `/blog`).*

* **Iniciar o servidor local (Live Reload):**
  ```bash
  ./scripts/helper.sh server
  ```

* **Compilar para produção:**
  ```bash
  ./scripts/helper.sh build
  ```

* **Upload de imagem para o S3/R2:**
  ```bash
  ./scripts/helper.sh upload-s3 ~/Imagens/screenshot.png
  ```

---

## 🚀 2. Executando o Blog Localmente

Para iniciar o servidor local com recarregamento em tempo real (Live Reload):

```bash
# Iniciar o servidor local (incluindo rascunhos)
./scripts/helper.sh server
# ou
hugo server -D
```

Acesse no navegador:
* 🇧🇷 **Português (Padrão)**: [http://localhost:1313/](http://localhost:1313/)
* 🇺🇸 **Inglês (Internacional)**: [http://localhost:1313/en/](http://localhost:1313/en/)
* 📚 **Arquivo do Blog**: [http://localhost:1313/blog/](http://localhost:1313/blog/)

---

## ✍️ 3. Como Criar Novos Posts

### 3.1 Via CLI Helper (Recomendado)
```bash
./scripts/helper.sh new-post "Título do Meu Artigo"
```

### 3.2 Estrutura de Pastas por Data (Ano/Mês/Dia)
Os posts ficam salvos na pasta correspondente à data de criação:

```text
content/
└── blog/
    ├── _index.md            # Índice da seção do blog (PT)
    ├── _index.en.md         # Índice da seção do blog (EN)
    └── 2026/
        └── 08/
            └── 28/
                ├── meu-post.md     # Versão em Português
                └── meu-post.en.md  # Versão internacional em Inglês
```

### 3.3 Exemplo de Post em Português (`meu-post.md`)
```yaml
---
title: "Meu Post de Exemplo"
date: 2026-08-28T21:45:00-03:00
slug: "meu-post-de-exemplo"
description: "Breve resumo do post para listagem e SEO."
tags: ["linux", "desenvolvimento", "produtividade"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Seu conteúdo em Markdown aqui...
```

---

## 🖼️ 4. Upload de Screenshots no S3/R2 com Thunar Custom Actions

Para não comitar imagens pesadas no Git, você pode clicar com o botão direito em qualquer imagem no gerenciador de arquivos **Thunar** e enviá-la para o S3 em 1 clique.

### 4.1 Configuração das Credenciais do S3
O arquivo `scripts/.env` guarda suas configurações do S3/R2:
```bash
S3_BUCKET_NAME="seu-bucket"
AWS_REGION="auto"
S3_FOLDER_PREFIX="screenshots"
S3_BASE_URL="https://pub-xxxxxxxxxxxxxx.r2.dev"
S3_ENDPOINT_URL="https://<account_id>.r2.cloudflarestorage.com"
AWS_ACCESS_KEY_ID="seu_access_key"
AWS_SECRET_ACCESS_KEY="seu_secret_key"
```

### 4.2 Como Usar no Thunar

1. Clique com o **botão direito** na imagem ou captura de tela no Thunar.
2. Selecione: 👉 **`Enviar Imagem para S3 (Blog)`**.
3. O script enviará para o bucket, disparará notificação no desktop via `notify-send` e colocará o link Markdown no seu clipboard (`wl-copy`).
4. Abra o seu post no editor e dê **`Ctrl + V`**!

---

## 🌐 5. Deploy no GitHub Pages

O projeto possui a automação configurada via GitHub Actions em [`.github/workflows/pages.yaml`](.github/workflows/pages.yaml).

### 5.1 Publicando Alterações
Toda vez que você fizer um commit e push para a branch `main`:
```bash
git add .
git commit -m "feat: novos posts e scripts"
git push origin main
```
O GitHub Actions irá compilar automaticamente o site com Hugo Extended e publicá-lo em:
👉 **`https://bardo-programador.github.io/`**
