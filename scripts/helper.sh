#!/usr/bin/env bash
# ==============================================================================
# CLI Helper do Blog Pessoal (Bardo Programador)
# Wrapper para facilitar a criação de posts, regeneração de índices e tarefas.
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Função de ajuda
show_help() {
    cat << EOF
🛠️  CLI Helper do Blog - Bardo Programador

Uso:
  $0 <comando> [argumentos]

Comandos principais:
  new-post <título>      Cria um novo post (.md e .en.md) com data atual e chama regenerate_index
  regenerate_index       Recria/atualiza os arquivos _index.md de / e /blog e mapeia os posts

Outros utilitários:
  upload-s3 <imagem>     Faz upload de uma screenshot para o bucket S3/R2 (usado no Thunar)
  server                 Inicia o servidor local de desenvolvimento (hugo server -D)
  build                  Compila o site estático para produção (hugo --gc --minify)
  help, -h, --help       Exibe esta mensagem de ajuda

Exemplos:
  $0 new-post "Meu Novo Artigo Sobre Linux"
  $0 regenerate_index
  $0 upload-s3 ~/Imagens/print.png
EOF
}

# Verificar se foi passado algum comando
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

COMMAND="$1"
shift

case "$COMMAND" in
    new-post|new_post|create-post)
        if [[ $# -eq 0 ]]; then
            echo "❌ Erro: Por favor informe o título do post."
            echo "Exemplo: $0 new-post 'Título do Meu Post'"
            exit 1
        fi
        python3 "${SCRIPT_DIR}/new_post.py" "$@"
        ;;

    regenerate_index|regenerate-index|regen|index)
        python3 "${SCRIPT_DIR}/regenerate_index.py" "$@"
        ;;

    upload-s3|upload_s3|s3)
        "${SCRIPT_DIR}/upload_s3.sh" "$@"
        ;;

    server|dev|serve)
        echo "🚀 Iniciando servidor Hugo..."
        cd "$PROJECT_DIR" && hugo server -D "$@"
        ;;

    build|compile)
        echo "📦 Compilando site para produção..."
        cd "$PROJECT_DIR" && hugo --cleanDestinationDir --gc --minify "$@"
        ;;

    help|-h|--help)
        show_help
        ;;

    *)
        echo "❌ Comando desconhecido: '$COMMAND'"
        echo ""
        show_help
        exit 1
        ;;
esac
