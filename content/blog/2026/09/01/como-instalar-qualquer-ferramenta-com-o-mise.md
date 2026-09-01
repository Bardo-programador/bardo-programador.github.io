---
title: "Como instalar qualquer ferramenta com o mise?"
date: 2026-09-01T11:23:16-03:00
slug: "como-instalar-qualquer-ferramenta-com-o-mise"
description: "Como usar o mise para centralizar a instalação de ferramentas no seu ambiente de desenvolvimento?"
tags: ["tech", "tutorial"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

# O que é o mise
o [mise](https://mise.jdx.dev/) (conhecido também como mise-en-place) é uma ferramenta que instala outras ferramentas. Com ele é possível
gerir e instalar diversas ferramentas de forma centralizada, facilitando a vida de desenvolvedores. Você pode instalar algumas ferramentas como versões de linguagem (Python, Java, Node, Golang e muitas outras) e até mesmo ferrametas CLI como de IA (Claude Code, Antigravity, Copilot) e diversas outras como o aws-cli.\
\
Eu pessoalmente acho muito chato ter que ficar indo atrás do site da ferramenta ou da linguagem de programação e ficar instalando tudo manualemente, mexendo no .rc e salvar no PATH, isso quando não é uma linguagem de programação onde tenho que instalar versões novas frequentemente. Mesmo com uma ferramenta específica para isso preciso instalar um ferramenta nova para cada linguagem. Com o mise resolvo isso com um comandinho e com facilidade de uso.\
\
Na data de publicação deste artigo existem +1000 ferrametas disponíveis para instalar e mais de 13 fontes diferentes (backends).

![screenshot_01 sep_11 34 25_24717](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-01-113504-screenshot_01-sep_11-34-25_24717.png)

# Como instalar o mise 

A forma mais fácil é com

```bash
curl https://mise.run | sh
```

O comando é para Linux/mac e instala o binário no seu ~/.local/bin. Para o Windows não sei, veja no [site oficial](https://mise.jdx.dev/getting-started.html#installing-mise-cli). Eu recomendo instalar via gerenciador de pacote do sistema(apt, dnf, yum, etc) para obter atualizações automáticas.\
Coloque essa linha no seu ~/.bashrc ou ~/.zshrc para ativar o mise, vai ser útil mais tarde.
```bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
```

Verifique a instalação com:
```bash
mise --version # ~/.local/bin/mise --version 
# 2026.8.14 linux-x64 (2024-12-20)

```


# Como usar?
Antes de instalar qualquer ferramenta, o mise usa arquivos .toml para guardar informações de ferrametas e versões. Por padrão, o mise guarda as ferramentas globais do usuário em ~/.config/mise/config.toml na seção `[tools]`.\
```bash
cat ~/.config/mise/config.toml
# [tools]
# go = "latest"
# hugo = "latest"
# python = "latest"
```

Para instalar uma ferramenta é muito simples
```bash
mise use --global python
python --version
# Python 3.14.7
```

Isso instala a última versão disponível do interpretador e salva no config.toml. Se quiser especificar uma versão, use a notação `<nome>@<versão>`, exemplo: python@3.10.4.
> [NOTE] Se não especificar a versão é equivalente a usar python@latest.


## exec 
Se você quiser executar uma ferramenta sem instalar, use o comando exec
```bash
mise exec node@26 -- node -v
# v26.x.x
```

# Usando em projetos
Agora como usaria em projetos? O mise cria um arquivo mise.toml ao usar `mise use` sem a flag --global semelhante ao do ~/.config/mise/config.toml dentro do diretório.

```bash
cd /tmp
mise use node@22
# node@22.23.2    10.9.8                                                                                                                                                                      ✔
# mise /tmp/mise.toml tools: node@22.23.2
cat mise.toml
# [tools]
# node = "22"
```

O melhor de tudo é que se você está com o mise ativado no shell, assim que você entra no diretório ele já ativa aquela versão especifica do node. 

```bash
cd /tmp
rm mise.toml

mkdir project-1
mkdir project-2

cd project-1
mise use node@20
node -v
# v20.20.2

cd ../project-2
mise use node@22
node -v
# v22.23.2

# Se tentar voltar para projetc-1 
cd ../project-1
node -v 
# v20.20.2

# Agora para project-2
cd ../project-2
node -v 
# v22.23.2


```

# Usando variáveis de ambiente (env vars)
Além de gerenciar versões de ferramentas, o mise também pode gerenciar variáveis de ambiente por diretório (substituindo ferramentas como o `direnv` ou `dotenv`). Você pode definir variáveis diretamente no seu `mise.toml` usando a seção `[env]` ou até mesmo carregar arquivos `.env`.

Assim que você entra no diretório do projeto, as variáveis são carregadas automaticamente no seu shell:

```toml
# mise.toml
[env]
NODE_ENV = "development"
PORT = "3000"
API_KEY = "segredo123"
_.file = ".env" # carrega automaticamente variáveis de um arquivo .env se existir
```

Você pode inspecionar e testar se as variáveis estão ativas:

```bash
# Dentro do diretório do projeto com mise ativado
echo $PORT
# 3000

# Ou listar todas as variáveis gerenciadas pelo mise
mise env
#export NODE_ENV=development
#export API_KEY=segredo123
#export GOBIN=/home/samuel/.local/share/mise/installs/go/1.27.0/bin
#export GOROOT=/home/samuel/.local/share/mise/installs/go/1.27.0
#export PATH='/home/samuel/.local/share/mise/installs/node/22/bin:/home/samuel/.local/share/mise/installs/go/1.27.0/bin:/home/samuel/.local/share/mise/installs/hugo/latest:/home/samuel/.local/share/mise/installs/python/latest/bin'
#export PORT=3000
```

# Rodando tasks no mise
O mise também possui um *task runner* integrado, servindo como uma alternativa prática a ferramentas como `make`, `just` ou scripts no `package.json`.

Você pode declarar tarefas diretamente no `mise.toml` sob a seção `[tasks]`:

```toml
# mise.toml
[tasks.lint]
description = "Roda a verificação de lint"
run = "npm run lint"
''
[tasks.build]
description = "Compila o projeto"
run = "npm run build"

[tasks.start]
description = "Inicia a aplicação após o build"
depends = ["build"]
run = "node dist/index.js"
```

Para listar e rodar as tasks:

```bash
# Listar todas as tarefas disponíveis no projeto
mise tasks

# Rodar uma tarefa específica (ou usar o atalho `mise r`)
mise run start # executa a tarefa em [tasks.start]
```

O grande benefício é que as tasks sempre são executadas com o ambiente correto, utilizando as versões de ferramentas do `[tools]` e as variáveis de ambiente configuradas no `[env]`.
