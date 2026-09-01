---
title: "How to install any tool with mise?"
date: 2026-09-01T11:23:16-03:00
slug: "how-to-install-any-tool-with-mise"
description: "How to use mise to centralize tool installation in your development environment?"
tags: ["tech", "tutorial"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

# What is mise
[mise](https://mise.jdx.dev/) (also known as mise-en-place) is a tool that installs other tools. With it, you can manage and install various tools in a centralized way, making developers' lives much easier. You can install tools like programming language versions (Python, Java, Node, Golang, and many others) and even CLI tools such as AI CLIs (Claude Code, Antigravity, Copilot) and several others like aws-cli.\
\
Personally, I find it very annoying to have to visit each tool or language website and install everything manually, editing .rc files and updating PATH—especially with programming languages where new versions need to be installed frequently. Even with specific version managers, you'd need a different tool for each language. With mise, I solve all of that with a single command and great ease of use.\
\
As of this article's publication date, there are +1000 tools available to install across more than 13 different sources (backends).

![screenshot_01 sep_11 34 25_24717](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-01-113504-screenshot_01-sep_11-34-25_24717.png)

# How to install mise

The easiest way is:

```bash
curl https://mise.run | sh
```

This command works for Linux/macOS and installs the binary in your `~/.local/bin`. For Windows, check the [official website](https://mise.jdx.dev/getting-started.html#installing-mise-cli). I recommend installing via your system package manager (apt, dnf, yum, etc.) to get automatic updates.\
Add this line to your `~/.bashrc` or `~/.zshrc` to activate mise (this will be useful later):
```bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
```

Verify the installation with:
```bash
mise --version # ~/.local/bin/mise --version 
# 2026.8.14 linux-x64 (2024-12-20)
```

# How to use it?
Before installing any tool, mise uses `.toml` files to store tool and version information. By default, mise stores global user tools in `~/.config/mise/config.toml` under the `[tools]` section.\
```bash
cat ~/.config/mise/config.toml
# [tools]
# go = "latest"
# hugo = "latest"
# python = "latest"
```

Installing a tool is very straightforward:
```bash
mise use --global python
python --version
# Python 3.14.7
```

This installs the latest available version of the interpreter and saves it to `config.toml`. If you want to specify a version, use the `<name>@<version>` notation, for example: `python@3.10.4`.
> [NOTE] If you don't specify the version, it is equivalent to using `python@latest`.

## exec
If you want to run a tool without installing it permanently, use the `exec` command:
```bash
mise exec node@26 -- node -v
# v26.x.x
```

# Using it in projects
How do you use it in projects? mise creates a `mise.toml` file when running `mise use` without the `--global` flag, similar to `~/.config/mise/config.toml`, but inside the project directory.

```bash
cd /tmp
mise use node@22
# node@22.23.2    10.9.8                                                                                                                                                                      ✔
# mise /tmp/mise.toml tools: node@22.23.2
cat mise.toml
# [tools]
# node = "22"
```

Best of all: if you have mise activated in your shell, as soon as you enter the directory, it automatically activates that specific version of node.

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

# If you go back to project-1
cd ../project-1
node -v 
# v20.20.2

# Now back to project-2
cd ../project-2
node -v 
# v22.23.2
```

# Using environment variables (env vars)
Besides managing tool versions, mise can also manage directory-scoped environment variables (replacing tools like `direnv` or `dotenv`). You can define variables directly in your `mise.toml` using the `[env]` section or even load `.env` files.

As soon as you enter the project directory, the variables are automatically loaded into your shell:

```toml
# mise.toml
[env]
NODE_ENV = "development"
PORT = "3000"
API_KEY = "segredo123"
_.file = ".env" # automatically loads variables from a .env file if it exists
```

You can inspect and check if the variables are active:

```bash
# Inside the project directory with mise activated
echo $PORT
# 3000

# Or list all variables managed by mise
mise env
#export NODE_ENV=development
#export API_KEY=segredo123
#export GOBIN=/home/samuel/.local/share/mise/installs/go/1.27.0/bin
#export GOROOT=/home/samuel/.local/share/mise/installs/go/1.27.0
#export PATH='/home/samuel/.local/share/mise/installs/node/22/bin:/home/samuel/.local/share/mise/installs/go/1.27.0/bin:/home/samuel/.local/share/mise/installs/hugo/latest:/home/samuel/.local/share/mise/installs/python/latest/bin'
#export PORT=3000
```

# Running tasks in mise
mise also includes a built-in task runner, serving as a practical alternative to tools like `make`, `just`, or scripts in `package.json`.

You can declare tasks directly in `mise.toml` under the `[tasks]` section:

```toml
# mise.toml
[tasks.lint]
description = "Run lint check"
run = "npm run lint"

[tasks.build]
description = "Build the project"
run = "npm run build"

[tasks.start]
description = "Start the application after build"
depends = ["build"]
run = "node dist/index.js"
```

To list and run tasks:

```bash
# List all available tasks in the project
mise tasks

# Run a specific task (or use the shortcut `mise r`)
mise run start # runs the task defined in [tasks.start]
```

The major benefit is that tasks always run with the correct environment, using the tool versions from `[tools]` and the environment variables configured in `[env]`.
