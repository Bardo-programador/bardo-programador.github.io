#!/usr/bin/env python3
# ==============================================================================
# Script: regenerate_index.py
# Finalidade: Recriar/validar os arquivos _index.md de / e /blog e mapear posts
# ==============================================================================

import os
import re
from datetime import datetime

def scan_posts(blog_dir: str):
    """Varre todos os posts da pasta content/blog/."""
    pt_posts = []
    en_posts = []

    for root, _, files in os.walk(blog_dir):
        for file in sorted(files):
            if file.startswith("_index"):
                continue
            if not file.endswith(".md"):
                continue

            full_path = os.path.join(root, file)
            with open(full_path, "r", encoding="utf-8") as f:
                content = f.read()

            title_match = re.search(r'^title:\s*["\']?(.*?)["\']?$', content, re.MULTILINE)
            date_match = re.search(r'^date:\s*["\']?(.*?)["\']?$', content, re.MULTILINE)

            title = title_match.group(1) if title_match else file
            date_str = date_match.group(1) if date_match else ""

            post_info = {
                "file": full_path,
                "title": title,
                "date": date_str,
                "name": file
            }

            if file.endswith(".en.md"):
                en_posts.append(post_info)
            else:
                pt_posts.append(post_info)

    # Ordenar por data mais recente
    pt_posts.sort(key=lambda x: x["date"], reverse=True)
    en_posts.sort(key=lambda x: x["date"], reverse=True)

    return pt_posts, en_posts

def ensure_indexes(project_root: str):
    content_dir = os.path.join(project_root, "content")
    blog_dir = os.path.join(content_dir, "blog")

    # 1. Root /_index.md (PT)
    root_pt = os.path.join(content_dir, "_index.md")
    root_pt_content = """---
title: "Bardo Programador"
framed: true
---

Olá, mundo! 👋 Bem-vindo ao meu blog pessoal e espaço de anotações sobre desenvolvimento, Linux, arquitetura e tecnologia.
"""
    if not os.path.exists(root_pt):
        with open(root_pt, "w", encoding="utf-8") as f:
            f.write(root_pt_content)
        print("  ➕ Criado: content/_index.md")

    # 2. Root /_index.en.md (EN)
    root_en = os.path.join(content_dir, "_index.en.md")
    root_en_content = """---
title: "Bardo Programador"
framed: true
---

Hello, world! 👋 Welcome to my personal blog and notebook about software development, Linux, architecture, and technology.
"""
    if not os.path.exists(root_en):
        with open(root_en, "w", encoding="utf-8") as f:
            f.write(root_en_content)
        print("  ➕ Criado: content/_index.en.md")

    # 3. Blog /blog/_index.md (PT)
    blog_pt = os.path.join(blog_dir, "_index.md")
    blog_pt_content = """---
title: "Blog"
cascade:
  type: blog
sidebar:
  open: false
---

Aqui você encontra artigos, anotações rápidas e tutoriais sobre desenvolvimento e tecnologia.
"""
    with open(blog_pt, "w", encoding="utf-8") as f:
        f.write(blog_pt_content)
    print("  ✓ Atualizado: content/blog/_index.md")

    # 4. Blog /blog/_index.en.md (EN)
    blog_en = os.path.join(blog_dir, "_index.en.md")
    blog_en_content = """---
title: "Blog"
cascade:
  type: blog
sidebar:
  open: false
---

Articles, quick notes, and tutorials on software development and technology.
"""
    with open(blog_en, "w", encoding="utf-8") as f:
        f.write(blog_en_content)
    print("  ✓ Atualizado: content/blog/_index.en.md")

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, ".."))
    blog_dir = os.path.join(project_root, "content", "blog")

    print("🔍 Mapeando índices e postagens do blog...")
    ensure_indexes(project_root)

    pt_posts, en_posts = scan_posts(blog_dir)
    print(f"\n📊 Total de Posts Encontrados:")
    print(f"  🇧🇷 Português: {len(pt_posts)} posts")
    for p in pt_posts[:5]:
        d = p['date'][:10] if p['date'] else 'Sem data'
        print(f"     • [{d}] {p['title']}")
    if len(pt_posts) > 5:
        print(f"     ... e mais {len(pt_posts) - 5} posts")

    print(f"  🇺🇸 Inglês:    {len(en_posts)} posts")
    for p in en_posts[:5]:
        d = p['date'][:10] if p['date'] else 'Sem data'
        print(f"     • [{d}] {p['title']}")
    if len(en_posts) > 5:
        print(f"     ... e mais {len(en_posts) - 5} posts")

    print("\n✅ Regeneração dos índices concluída com sucesso!")

if __name__ == "__main__":
    main()
