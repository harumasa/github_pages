---
title: "Create a static website with Hugo and Host it with Github Pages"
date: 2020-08-29T00:00:00+09:00
lastmod: 2022-07-24T00:00:00+09:00
draft: false
---

## Introduction

- Model: MacBook Pro (13-inch, 2016, Four Thunderbolt 3 Ports)
- OS: macOS Monterey
- Hugo

## Setup Hugo

### 1. Install Hugo

```zsh
brew install hugo
```

### 2. Create a New Site

```zsh
hugo new site github_pages
```

### 3. Add a Theme

```zsh
cd ~/github_pages
git init
git submodule add https://github.com/alex-shpak/elephants.git themes/elephants
echo theme = \"elephants\" >> config.toml
```

### 4. Add Some Content

```zsh
cd ~/github_pages/content
hugo new github_pages_01.md
```

```zsh
vim ~/github_pages/content/github_pages_01.md

---
title: "TITLE"
date: 2022-01-01T00:00:00+09:00
lastmod: 2022-01-01T00:00:00+09:00
draft: false
---

## XXXXXXXX
+++
```

### 5. Start the Hugo server

```zsh
hugo server --theme=elephants --buildDrafts --watch
```

### 6. Customize the Theme

```zsh
vim ~/github_pages/config.toml

baseURL = "https://${USERNAME}.github.io/github_pages/"
languageCode = "ja-jp"
publishDir = "docs"
theme = "hugo-book"
title = "${TITLE}"
```

### 7. Build static pages

```zsh
hugo
```

## Setup GitHub Pages

### 1. Create GitHub Repository

Create GitHub Repository `github_pages`

### 2. Configure GitHub Pages

[Configuring a publishing source for your GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site/ "Configuring a publishing source for your GitHub Pages site")

### 3. Create ShellScript

```zsh
cd ~/github_pages
git init
git add -A
git commit -m "first commit"
git remote add origin git@github.com:${USERNAME}/github_pages.git
git push -u origin master
```

```zsh
vim ~/github_pages/deploy.sh

#!/bin/bash

LANG=C

echo -e "\033[0;33mDeploying updates to GitHub...\033[0m"

# Build the project
hugo

# Add changes to git
git add -A

# Commit changes
msg="commit `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos
git push origin master
```

```zsh
chmod +x deploy.sh
```

```zsh
./deploy.sh
```
