---
title: "How to setup macOS Monterey (Hyper, Visual Studio Code, Docker, Git, BetterSnapTool)"
date: 2020-08-29T00:00:00+09:00
lastmod: 2022-08-09T00:00:00+09:00
draft: false
---

## Introduction

- Model: MacBook Pro (13-inch, 2016, Four Thunderbolt 3 Ports)
- OS: macOS Monterey
- Hyper
- Visual Studio Code
- Docker
- Git
- BetterSnapTool

## macOS Monterey

### 1. System Preferences

#### 1.1. General

- Click in the scroll bar to: Jump to the spot that's clicked
- Prefer tabs: Turn on Ask to keep changes when closing documents

#### 1.2. Desktop & Screen Saver

##### 1.2.2. Screen Saver

- Turn off Show screen saver after

#### 1.3. Dock & Menue Bar

##### 1.3.1. Dock & Menue Bar

- Minimize windows using: Scale effect
- Turn on Double-click a window's title bar to: minimize
- Turn on Minimize windows into application icon
- Turn on Automatically hide and show the Dock

##### 1.3.14. Clock

- Data options:
  - Turn on Show the date of the week
- Time options:
  - Turn on Display the time with seconds

##### 1.3.16. Siri

- Turn off Show Siri in menu bar

#### 1.4. Mission Control

- Turn off Automatically rearrange Spaces based on most recent use

#### 1.7. Language & Region

- Preferred languages: English - Primary, Japanese

#### 1.13. Accessibility

##### 1.13.10. Pointer Control > Mouse & Trackpad

- Trackpad Options
  - Turn on Enable dragging: three finger drag

#### 1.16. Security & Privacy

- Advanced
  - Turn on Require an administrator password to access system-wide preferences

##### 1.16.1. General

- Require password: immediately after sleep or screen saver begins
- Turn on Use your Apple Watch to unlock apps your Mac

##### 1.16.3. Firewall

- Turn on Firewall
- Firewall Options
  - Turn off Automatically allow build-in software to receive incoming connections
  - Turn on Enable stealth mode

#### 1.17. Software Update

- Turn on Automatically keep my Mac up to date

#### 1.19. Bluetooth

- Turn on Show Bluetooth in menu bar

#### 1.22. Keyboard

##### 1.22.1. Keyboard

- Key Repeat: Most Fast
- Delay Until Repeat: Most Short
- Modifier Keys
  - Caps Lock Key: Command

##### 1.22.2. Text

- Turn off Correct spelling automatically
- Turn off Capitalize words automatically
- Turn off Add period with double-space
- Turn off Touch Bar typing suggestions
- Turn off Use smart quotes and dashes

##### 1.22.3. Shortscuts

- Keyboard
  - Move focus to next window: option + tab

##### 1.22.4. Input Sources

- Japanese - Romaji
  - "¥" key generates: \ (Backslash)

##### 1.22.5. Dictation

- Dictation: On

#### 1.23. Trackpad

##### 1.23.1. Point & Click

- Tracking speed: Most Fast

##### 1.23.3. More Gestures

- Turn on App Expose

#### 1.29. Sharing

- Change Computer Name: ${COMPUTERNAME}

#### 1.30. Time Machine

- Turn on Back Up Automatically
- Turn on Show Time Machine in Menu bar

### 2. Desktop

- Turn on Use Stacks

### 3. Finder

#### 3.1. Preferences

##### 3.1.1. General

- New Finder windows show: ${USERNAME}

##### 3.1.3. Sidebar

- Show these items in the sidebar

##### 3.1.4. Advanced

- Turn on Show all filename extensions

#### 3.4. View

- as Columns
- Show Path Bar
- Show Status Bar

#### 3.5. Go

- AirDrop
  - Allow me to be discovered by: No One

### 4. Safari

#### 4.1. Preferences

##### 4.1.1. General

- Turn off Open "safe" files after downloading

##### 4.1.10. Advanced

- Turn on Show full website address
- Default encoding: Unicode (UTF-8)
- Turn on Show Develop menu in menu bar

#### 4.4. View

- Show Status Bar

### 5. FaceTime

#### 5.1. Preferences

##### 5.1.1 Settings

- you can be reached for FaceTime at:

### 6. Messages

#### 6.1. Preferences

##### 6.1.2 iMessage

- Turn on Enable Messages in iCloud
- you can be reached for messages at:
- Turn on Send read receipts

### 7. Terminal

#### 7.1. Preferences

##### 7.1.2. Profiles

- Profiles
  - [Iceberg](https://cocopon.github.io/iceberg.vim/ "Iceberg")
- Text
  - Background
    - Color & Effects > Opacity: 80%
  - Font > [Ricty Diminished](https://github.com/edihbrandon/RictyDiminished/ "Ricty Diminished") & Size 18pt

## Prezto

- [Prezto](https://github.com/sorin-ionescu/prezto/ "Prezto")

Install Command Line Tools

```zsh
xcode-select --install
```

Check for Command Line Tools updates

```zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

```zsh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
```

```zsh
vim ~/.zpreztorc

+++
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'autosuggestions' \ # Add
  'git' \ # Add
  'history-substring-search' \ # Add
  'syntax-highlighting' \ # Add
  'prompt'
+++
# Auto set to 'off' on dumb terminals.
zstyle ':prezto:module:prompt' theme 'pure' # sorin to pure
+++
```

```zsh
source ~/.zpreztorc
```

## Homebrew

- [Homebrew](https://brew.sh/ "Homebrew")

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```zsh
brew cask install hyper
brew cask install visual-studio-code
brew cask install docker
brew install git
```

## Hyper

- [Hyper](https://hyper.is "Hyper")

### 1. Preferences

```zsh:.hyper.js
+++
module.exports = {
  config: {
    +++
    // default font size in pixels for all tabs
    fontSize: 18, # Change

    // font family with optional fallbacks
    fontFamily: 'Ricty Diminished', # Change
    +++
    +++
    // rest of the config # Add
    opacity: 0.80, # Add
  },
  +++
  +++
  plugins: [
    "hyper-material-theme", # Add
    "hyper-opacity", # Add
  ],
  +++
};
```

## Visual Studio Code

- [Visual Studio Code](https://azure.microsoft.com/en-us/products/visual-studio-code/ "Visual Studio Code")

### 1. Accounts

- Setting Sync is On

Installed Extensions

- Docker
- GitHub Theme
- GlassIt-VSC
- Jupyter
- Jupyter Keymap
- Jupyter Notebook Renderers
- markdownlint
- Marp for VS Code
- Material Icon Theme
- Path Intellisense
- Prettier - Code formatter
- Pylance
- Python
- Remote - Containers
- Remote - SSH
- Remote - WSL
- Remote Development
- Trailing Spaces
- YAML

## Docker Desktop

- [Docker](https://www.docker.com "Docker")

### 1. Preferences

#### 1.4. Advanced

- Memory: [$X]GB (Default: 2GB)

### 2. Directory Structure

#### 2.1. Directory Structure

```zsh
.
├── .dockerignore
├── .gitignore
├── data/      # Data Files
├── docker-compose.yml
├── Dockerfile
└── notebook/  # Jupyter Notebook Files
```

#### 2.2. .dockerignore

```zsh
data
notebook
```

#### 2.3. .gitignore

- [github/gitignore](https://github.com/github/gitignore/ "github/gitignore")

```zsh:
# Python
+++
```

#### 2.5. docker-compose.yml

```zsh
version: "3"
services:
  jupyter:
    build: .
    command: jupyter notebook --allow-root --ip=0.0.0.0 --no-browser
    ports:
      - 8888:8888
    volumes:
      - ./notebook:/dev/work
    working_dir: /dev/work
```

#### 2.6. Dockerfile

```zsh
FROM gcr.io/kaggle-images/python:v119 # Use specific version (:latest Use latest version)

RUN pip install -U pip
```

### 3. Jupyter Notebook

Launch Jupyter Notebook

```zsh
docker-compose up -d --build
```

Check logs

```zsh
+++
jupyter_1  |    To access the notebook, open this file in a browser:
jupyter_1  |        file:///home/jovyan/.local/share/jupyter/runtime/nbserver-6-open.html
jupyter_1  |    Or copy and paste one of these URLs:
jupyter_1  |        http://XXXXXXXXXXXX:8888/?token=XXXXXXXXXXXX
jupyter_1  |     or http://127.0.0.1:8888/?token=XXXXXXXXXXXX
```

## Git

- [Git](https://git-scm.com "Git")

### 1. Initial setting

```zsh
git config --global user.name ${USERNAME}
git config --global user.email ${USEREMAIL}
git config --global color.ui true
git config --global help.autocorrect 1
```

### 2. Global gitignore

```zsh
vim ~/.gitignore_global

Copy and paste the contents of [github/gitignore](https://github.com/github/gitignore/ "github/gitignore")
```

Enable global gitignore

```zsh
git config --global core.excludesfile ~/.gitignore_global
```

### 3. GitHub

- [GitHub](https://github.com/ "GitHub")

#### 3.1. Settings

- Security
  - Enable Two-factor authentication

#### 3.2. Clone with HTTPS

Generate Personal Access Token

- Setting > Developer settings > Personal access tokens
  - Generate new token > Turn on repo > Generate token

Use Personal Access Token instead of password

#### 3.3. Clone with SSH

Generate SSH keys

```zsh
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -t rsa -C ${REGISTEREDMAIL}

Enter enter
Enter passphrase
Enter same passphrase again
```

Add connection settings to config

```zsh
vim ~/.ssh/config

# global setting for macOS

Host *
  AddKeysToAgent yes
  UseKeychain yes

Host github
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  User git
```

```zsh
cd ~/.ssh
chmod 600 id_rsa
```

```zsh
ssh-add ~/.ssh/id_rsa
ssh-add -l
```

```zsh
pbcopy < ~/.ssh/id_rsa.pub

Settings > SSH and GPG keys > New SSH key > Paste to Key > Add key
```

```zsh
ssh -T git@github.com
```

```zsh
ssh git@github.com
```

## BetterSnapTool

Install BetterSnapTool from App Store

### 1. Preferences

#### 1.1 General Settings

- Turn on Start BetterSnapTool everytime your Mac starts up
- Turn off Show menubar icon (click twice on the app icon to open this preferences if hidden)

#### 1.3. Keyboard Shortcuts

- maximize: shift + command + F
- left half: shift + command + ←
- right half: shift + command + →
- top half: shift + command + ↑
- bottom half: shift + command + ↓
