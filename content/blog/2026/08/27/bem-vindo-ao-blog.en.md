---
title: "Welcome to my new Personal Blog"
date: 2026-08-27T20:00:00-03:00
slug: "bem-vindo-ao-blog"
description: "Introducing the new personal blog structure, international posts support, and S3 integration."
tags: ["blog", "hugo", "hextra", "linux"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

Welcome to my personal blog! 🚀

This blog is built using [Hugo](https://gohugo.io/) and the [Hextra](https://imfing.github.io/hextra) theme, providing fast load times, native dark mode, and seamless internationalization.

---

## What will you find here?

1. **Software Engineering**: Architectural discussions, APIs, and development practices.
2. **Linux & Daily Tooling**: Shell scripts, command-line utilities, and productivity workflows.
3. **International Content**: Bilingual and international technical posts for a wider audience.

---

## Code Example

Here is a quick Shell snippet:

```bash
# Start local Hugo development server
hugo server -D

# Upload a screenshot directly to S3
./scripts/upload_s3.sh ~/Pictures/my-screenshot.png
```

---

## S3 Image & Screenshot Workflow

To keep this Git repository lightweight, images and screenshots are uploaded directly to an S3 bucket.

Images can be inserted using standard Markdown or via our custom shortcode:

```markdown
{{</* s3img src="screenshots/2026/08/example.png" alt="Demo" caption="Screenshot hosted on S3" */>}}
```

Feel free to explore and toggle the language switcher in the navbar!
