#!/usr/bin/env bash
# ==============================================================================
# Script: upload_s3.sh
# Finalidade: Upload de imagens/screenshots para S3/R2 via CLI ou Thunar Custom Action
# Copia automaticamente o Markdown gerado para a Área de Transferência e envia notificação.
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# 1. Carregar e exportar variáveis de configuração (.env)
ENV_LOADED=false
for ENV_PATH in "${SCRIPT_DIR}/.env" "${PROJECT_DIR}/.env" "${HOME}/.config/bardo-blog/s3.env"; do
    if [[ -f "$ENV_PATH" ]]; then
        # Exporta automaticamente as variáveis carregadas para os subprocessos (aws cli)
        set -a
        # shellcheck disable=SC1090
        source "$ENV_PATH"
        set +a
        ENV_LOADED=true
        break
    fi
done

# Função de Notificação Desktop
send_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    local icon="${4:-image-x-generic}"

    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u "$urgency" -i "$icon" "$title" "$message"
    fi
}

# Função de Cópia para o Clipboard
copy_to_clipboard() {
    local text="$1"
    if command -v wl-copy >/dev/null 2>&1; then
        printf "%s" "$text" | wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        printf "%s" "$text" | xclip -selection clipboard
    elif command -v xsel >/dev/null 2>&1; then
        printf "%s" "$text" | xsel --clipboard --input
    fi
}

# Validações iniciais de parâmetros
if [[ $# -eq 0 ]]; then
    echo "Uso: $0 <caminho-da-imagem> [imagem2 ...]"
    echo "Exemplo: $0 ~/Imagens/screenshot.png"
    exit 1
fi

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    shift
fi

# Configurações com valores padrão
AWS_REGION="${AWS_REGION:-auto}"
export AWS_REGION
export AWS_DEFAULT_REGION="$AWS_REGION"
S3_FOLDER_PREFIX="${S3_FOLDER_PREFIX:-screenshots}"

# Sanitizar S3_ENDPOINT_URL (remover trailing slash e nome do bucket caso inserido por engano)
if [[ -n "$S3_ENDPOINT_URL" ]]; then
    S3_ENDPOINT_URL="${S3_ENDPOINT_URL%/}"
    if [[ -n "$S3_BUCKET_NAME" && "$S3_ENDPOINT_URL" == */"$S3_BUCKET_NAME" ]]; then
        S3_ENDPOINT_URL="${S3_ENDPOINT_URL%/"$S3_BUCKET_NAME"}"
    fi
fi

if [[ "$DRY_RUN" == false ]]; then
    if [[ -z "$S3_BUCKET_NAME" ]]; then
        ERR_MSG="S3_BUCKET_NAME não configurado. Crie o arquivo scripts/.env ou configure as variáveis."
        echo "❌ ERRO: $ERR_MSG" >&2
        send_notification "Erro no Upload S3 (Blog)" "$ERR_MSG" "critical" "dialog-error"
        exit 1
    fi

    if ! command -v aws >/dev/null 2>&1; then
        ERR_MSG="AWS CLI ('aws') não encontrado no PATH."
        echo "❌ ERRO: $ERR_MSG" >&2
        send_notification "Erro no Upload S3 (Blog)" "$ERR_MSG" "critical" "dialog-error"
        exit 1
    fi

    # Verificação de segurança para Cloudflare R2
    if [[ "$S3_ENDPOINT_URL" =~ "r2.cloudflarestorage.com" ]]; then
        KEY_LEN=${#AWS_ACCESS_KEY_ID}
        if [[ $KEY_LEN -ne 32 && $KEY_LEN -gt 0 ]]; then
            ERR_MSG="O AWS_ACCESS_KEY_ID possui $KEY_LEN caracteres. No Cloudflare R2, o Access Key ID deve ter exatamente 32 caracteres hexadecimais (você pode ter copiado o 'Token Value' em vez do 'Access Key ID')."
            echo "❌ ERRO: $ERR_MSG" >&2
            send_notification "Erro Credencial R2" "$ERR_MSG" "critical" "dialog-error"
            exit 1
        fi
    fi
fi

ALL_MARKDOWN=""
COUNT=0

for FILE in "$@"; do
    if [[ ! -f "$FILE" ]]; then
        echo "⚠️  Aviso: Arquivo não encontrado: $FILE" >&2
        continue
    fi

    FILENAME=$(basename "$FILE")
    EXT="${FILENAME##*.}"
    EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
    BASENAME_NO_EXT="${FILENAME%.*}"

    # Sanitizar nome para URL
    SLUG=$(echo "$BASENAME_NO_EXT" | iconv -t ascii//TRANSLIT 2>/dev/null | tr -cd '[:alnum:]_-' | tr '[:upper:]' '[:lower:]')
    if [[ -z "$SLUG" ]]; then
        SLUG="screenshot"
    fi

    # Estrutura de data YYYY/MM/YYYY-MM-DD-HHMMSS-slug.ext
    YEAR=$(date +%Y)
    MONTH=$(date +%m)
    TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
    
    S3_KEY="${S3_FOLDER_PREFIX}/${YEAR}/${MONTH}/${TIMESTAMP}-${SLUG}.${EXT_LOWER}"

    # Determinar Content-Type
    case "$EXT_LOWER" in
        png)  CONTENT_TYPE="image/png" ;;
        jpg|jpeg) CONTENT_TYPE="image/jpeg" ;;
        webp) CONTENT_TYPE="image/webp" ;;
        gif)  CONTENT_TYPE="image/gif" ;;
        svg)  CONTENT_TYPE="image/svg+xml" ;;
        *)    CONTENT_TYPE="application/octet-stream" ;;
    esac

    # Montar URL pública
    if [[ -n "$S3_BASE_URL" ]]; then
        PUBLIC_URL="${S3_BASE_URL%/}/${S3_KEY}"
    else
        PUBLIC_URL="https://${S3_BUCKET_NAME}.s3.${AWS_REGION}.amazonaws.com/${S3_KEY}"
    fi

    # Montar Markdown snippet
    ALT_TEXT="${SLUG//-/ }"
    MARKDOWN_SNIPPET="![${ALT_TEXT}](${PUBLIC_URL})"
    SHORTCODE_SNIPPET="{{< s3img src=\"${S3_KEY}\" alt=\"${ALT_TEXT}\" >}}"

    echo "--------------------------------------------------"
    echo "Arquivo: $FILE"
    echo "S3 Key:  $S3_KEY"
    echo "URL:     $PUBLIC_URL"
    echo "Markdown: $MARKDOWN_SNIPPET"
    echo "Shortcode: $SHORTCODE_SNIPPET"

    if [[ "$DRY_RUN" == true ]]; then
        echo "ℹ️  Modo Dry-Run: upload simulado com sucesso."
    else
        ENDPOINT_ARGS=()
        if [[ -n "$S3_ENDPOINT_URL" ]]; then
            ENDPOINT_ARGS+=(--endpoint-url "$S3_ENDPOINT_URL")
        fi

        echo "Enviando para s3://${S3_BUCKET_NAME}/${S3_KEY}..."
        aws s3 cp "$FILE" "s3://${S3_BUCKET_NAME}/${S3_KEY}" \
            --content-type "$CONTENT_TYPE" \
            "${ENDPOINT_ARGS[@]}"

        echo "✅ Upload concluído!"
    fi

    if [[ -z "$ALL_MARKDOWN" ]]; then
        ALL_MARKDOWN="$MARKDOWN_SNIPPET"
    else
        ALL_MARKDOWN="${ALL_MARKDOWN}\n${MARKDOWN_SNIPPET}"
    fi
    COUNT=$((COUNT + 1))
done

if [[ $COUNT -gt 0 ]]; then
    copy_to_clipboard "$ALL_MARKDOWN"
    echo "--------------------------------------------------"
    echo "📋 Link Markdown copiado para a Área de Transferência!"

    if [[ $COUNT -eq 1 ]]; then
        send_notification "S3 Upload Concluído" "Link Markdown copiado para a Área de Transferência!\n$PUBLIC_URL" "normal" "$1"
    else
        send_notification "S3 Upload Concluído" "$COUNT imagens enviadas! Links copiados para a Área de Transferência." "normal" "image-x-generic"
    fi
fi
