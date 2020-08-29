---
title: "Hugo + GitHub Pages でブログを作成する"
date: 2020-08-29T00:00:00+09:00
lastmod: 2020-08-29T00:00:00+09:00
draft: false
---

## はじめに

- Model: MacBook Pro (13-inch, 2016, Four Thunderbolt 3 Ports)
- OS: macOS Catalina 10.15.6
- Hugo 0.74.3

ターミナルから以下の手順でブログ記事を更新し GitHub Pages への公開までをシェルスクリプトで自動化します。

```zsh
# Hugo によって生成されたプロジェクトのルートディレクトリまで移動します。
cd ~/github_pages

# 新規マークダウンファイルを作成し編集します。
hugo new github_pages.md

# シェルスクリプトを実行します。
./deploy.sh
```

## Hugo の設定

### 1. インストール

Hugo をインストールします。

```zsh
brew install hugo
```

Hugo プロジェクトを作成します。

```zsh
hugo new site github_pages
```

### 2. テーマのダウンロード

公式サイト [Hugo](https://gohugo.io/ "Hugo") の [Hugo テーマ一覧](https://themes.gohugo.io/ "Hugo テーマ一覧") からテーマを選び `git clone` します。

```zsh
cd ~/github_pages
git clone https://github.com/rakuishi/hugo-zen.git themes/hugo-zen
```

### 3. 記事の作成

`github_pages.md` を作成します。

```zsh
cd ~/github_pages/content
hugo new github_pages.md
```

`github_pages.md` を編集します。

```zsh
vim ~/github_pages/content/github_pages.md
```

```md:github_pages.md
---
title: "TITLE"
date: 2020-01-01T00:00:00+09:00
draft: false
---

## XXXXXXXX
+++
```

### 4. 設定ファイルの編集

`config.toml` を編集します。

```zsh
vim ~/github_pages/config.toml
```

```toml:config.toml
author = "${AUTHOR}"
baseURL = "https://${USERNAME}.github.io/github_pages/"
copyright = "${USERNAME} All rights reserved."
languageCode = "ja"
publishDir = "docs" # html 生成先を public から docs へ変更
theme = "hugo-zen"
title = "${TITLE}"
uglyurls = true

[params]
github = "https://github.com/${USERNAME}/"
logo = "./images/logo.jpg" # ~/github_pages/themes/hugo-zen/static/images/logo.jpg
```

### 5. 公開用ファイルの作成

以下を実行するとブラウザで `localhost:1313/github_pages` からプレビューを確認することができます。

```zsh
hugo server --theme=hugo-zen --buildDrafts --watch
```

- `--theme`: プレビュー時にテーマを指定します
- `--buildDrafts`: `draft: true` となっている下書き状態のファイルもプレビューに表示します
- `--watch`: `.md` ファイルを更新する度にブラウザ側のプレビューも自動で更新されます

以下を実行すると `~/github_pages/docs` に公開用ファイルが作成されます。

```zsh
hugo
```

## GitHub Pages の設定

### 1. リポジトリの作成

GitHub 上で公開用リポジトリ `github_pages` を作成します。

`docs` の内容が `https://${USERNAME}.github.io/github_pages/` にて公開されます。

以下を実行します。

```zsh
cd ~/github_pages
git init
git add -A
git commit -m "first commit"
git remote add origin git@github.com:${USERNAME}/github_pages.git
git push -u origin master
```

### 2. GitHub での設定変更

GitHub 上の `Settings` から GitHub Pages の source を `master branch/docs folder` へ変更します。

### 3. シェルスクリプトの作成

`deploy.sh` を編集します。

```zsh
vim ~/github_pages/deploy.sh
```

```sh:deploy.sh
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

シェルスクリプトを実行できるようにします。

```zsh
chmod +x deploy.sh
```

以下を実行することでリポジトリに push され，`https://${USERNAME}.github.io/github_pages/` にてブログが表示されます。

```zsh
./deploy.sh
```
