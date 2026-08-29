---
title: "My First Post"
date: 2026-08-29T18:24:21-03:00
slug: "my-first-post"
description: "An introduction and welcome to the blog."
tags: []
authors: 
- name: "Samuel Roberto" 
link: "https://github.com/Bardo-programador"
---

## Home of the Blog
I'm publishing my first post on my new blog. The inspiration for creating a blog was from Fábio Akita at [https://akitaonrails.com/](https://akitaonrails.com/).
I find the content of the articles very useful and of great value, so I decided to create an article to publish my content. I aim to publish tutorials, technical content
or anything else you think is cool to post.


# How did I create this blog?

To create the blog, I decided to use [Hugo](https://gohugo.io/) with the [Hextra](https://imfing.github.io/hextra/) customization system, specifically I used the [re-Terminal](https://themes.gohugo.io/themes/hugo-theme-re-terminal/) theme with some customizations for the blog. I thought it was really cool, so I decided to use it.
I'm not going to give many details about how Hugo works, but basically the content of the posts are in content/. Layout/ deals with the structure and coding of the pages.

I also created some scripts that so far help create new posts and update the list of posts on /blog and /. I plan to create content in English too, when I create a new post it already generates an English version of the post (so far I need to translate it by force or translator). At the moment, the CLI I created has these functions.

```
❯ scripts/helper.sh                             
🛠️ CLI Blog Helper - Bardo Programador

Usage: 
  scripts/helper.sh <command> [arguments]

Main commands: 
  new-post <title>        Creates a new post (.md and .en.md) with current date and calls regenerate_index 
  regenerate_index        Recreates/updates the _index.md files of / and /blog and maps the posts

Other utilities: 
  upload-s3 <image>       Uploads a screenshot to the S3/R2 bucket (used in Thunar) 
  server                  Starts the local development server (hugo server -D) 
  build                   Compiles the static site for production (hugo --gc --minify) 
  help, -h, --help        Display this help message

Examples: 
  scripts/helper.sh new-post "My New Linux Article" 
  scripts/helper.sh regenerate_index 
  scripts/helper.sh upload-s3 ~/Images/print.png
```


## Screenshots to Cloudflare R2
To handle sending screenshots for the blog, I use Cloudflare's S3, Cloudflare R2. I decided to use it because I can use 10GB of storage indefinitely and for the purpose of the blog I believe it is more than enough. I created a script along with a custom action in Thunar to right-click on the image, send it to R2 and copy it to the clipboard formatted in Markdown to use the link, it's very practical.

## Deploy with Pages
Pro deploy I use Github Pages to host the blog. With each push in main, Action redoes the deployment and updates the blog page.

# Structure
The complete structure looks like this:
```
.
├── .github/workflows/pages.yaml # CI/CD pipeline for GitHub Pages
├── content/ # Blog content in Markdown
│   ├── _index.md / _index.en.md # Landing page (PT / EN)
│   ├── about.md / about.en.md # About Page (PT / EN)
│   └── blog/ # Posts organized by date (YYYY/MM/DD/)
├── layouts/ # Templates and shortcodes overrides
│   ├── _default/baseof.html # Base structure with full-width footer
│   ├── blog/list.html # Clean listing in h5 grouped by month
│   ├── partials/ # Header, menu and language selector
│   └── shortcodes/s3img.html # Shortcode for images hosted on S3/R2
├── scripts/ # CLI Helpers and local automations
│   ├── helper.sh # Main command wrapper
│   ├── new_post.py # Automatic post generator
│   ├── regenerate_index.py # Index validator and regenerator
│   └── upload_s3.sh # Upload screenshots to S3 (CLI & Thunar)
├── static/ # Static resources and CSS customizations
│   ├── style.css # Style customizations (font 150%, footer)
│   └── styles.css # Theme base stylesheet
└── hugo.yaml # Central site configuration
```

The rest of the project is in [My repository](https://github.com/Bardo-programador/bardo-programador.github.io). If you have any suggestions, criticisms or just want to talk to me, just upload an Issue or send a message on my [Linkedin](https://www.linkedin.com/in/samuel-roberto-635666229/).
