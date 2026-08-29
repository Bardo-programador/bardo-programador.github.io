#!/usr/bin/env python3
# ==============================================================================
# Script: new_post.py
# Finalidade: Criar um novo post com data atual, slug automático e front matter
# ==============================================================================

import sys
import os
import re
import unicodedata
import subprocess
from datetime import datetime

def slugify(text: str) -> str:
    """Gera um slug limpo para o nome do arquivo e URL."""
    text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode("ascii")
    text = re.sub(r"[^\w\s-]", "", text).strip().lower()
    return re.sub(r"[-\s]+", "-", text) or "novo-post"

def create_post(title: str, bilingual: bool = True) -> list:
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, ".."))
    content_blog_dir = os.path.join(project_root, "content", "blog")

    now = datetime.now().astimezone()
    year = now.strftime("%Y")
    month = now.strftime("%m")
    day = now.strftime("%d")
    iso_date = now.isoformat(timespec="seconds")

    slug = slugify(title)
    post_dir = os.path.join(content_blog_dir, year, month, day)
    os.makedirs(post_dir, exist_ok=True)

    pt_file_path = os.path.join(post_dir, f"{slug}.md")
    en_file_path = os.path.join(post_dir, f"{slug}.en.md")
    created_files = []

    # Conteúdo padrão em Português
    pt_content = f"""---
title: "{title}"
date: {iso_date}
slug: "{slug}"
description: "Descrição breve do post para SEO e listagem."
tags: ["tech", "dia-a-dia"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Escreva aqui o conteúdo do seu post em Markdown...
"""

    # Conteúdo padrão em Inglês (internacional)
    en_content = f"""---
title: "{title}"
date: {iso_date}
slug: "{slug}"
description: "Brief summary of the post for SEO and archive."
tags: ["tech", "daily-notes"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Write your post content in English here...
"""

    # Criar arquivo PT se não existir
    if not os.path.exists(pt_file_path):
        with open(pt_file_path, "w", encoding="utf-8") as f:
            f.write(pt_content)
        created_files.append(pt_file_path)
    else:
        print(f"⚠️  Arquivo em português já existe: {pt_file_path}")

    # Criar arquivo EN se solicitado
    if bilingual:
        if not os.path.exists(en_file_path):
            with open(en_file_path, "w", encoding="utf-8") as f:
                f.write(en_content)
            created_files.append(en_file_path)

    return created_files

def main():
    if len(sys.argv) < 2:
        print("Uso: new_post.py <título-do-post> [--no-en]")
        print("Exemplo: new_post.py 'Meu Primeiro Post no Terminal'")
        sys.exit(1)

    title_args = [arg for arg in sys.argv[1:] if not arg.startswith("--")]
    if not title_args:
        print("❌ Erro: Você precisa fornecer um título para o post.")
        sys.exit(1)

    title = " ".join(title_args)
    bilingual = "--no-en" not in sys.argv

    print(f"📝 Criando novo post: '{title}'...")
    created = create_post(title, bilingual=bilingual)

    for path in created:
        rel_path = os.path.relpath(path, os.path.join(os.path.dirname(__file__), ".."))
        print(f"✅ Criado: {rel_path}")

    # Executar a regeneração de índices automaticamente
    regen_script = os.path.join(os.path.dirname(__file__), "regenerate_index.py")
    if os.path.exists(regen_script):
        print("\n🔄 Atualizando índices do blog...")
        subprocess.run([sys.executable, regen_script], check=False)

if __name__ == "__main__":
    main()
