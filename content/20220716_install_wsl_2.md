---
title: "[Unfinished] How to install WSL 2 (Windows Subsystem for Linux 2) on Windows 11"
date: 2022-07-16T00:00:00+09:00
lastmod: 2022-08-09T00:00:00+09:00
draft: false
---

## Introduction

- Model: DELL Inspiron 14 (5485)
- OS: Windows 11
- PowerShell 7
- Windows Terminal
- Visual Studio Code
- WSL 2
- Docker Engine

## PowerShell 7

[PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/ "PowerShell Documentation")

## Windows Terminal

[What is Windows Terminal?](https://docs.microsoft.com/en-us/windows/terminal/ "What is Windows Terminal?")

### 1. Settings

#### 1.1. Startup

- Default profile: PowerShell (PowerShell 7)
- Default terminal application: Windows Terminal

Append to JSON file.

[Ricty Diminished](https://github.com/edihbrandon/RictyDiminished/ "Ricty Diminished")

```powershell:settings.json
+++
"defaults":
        {
            "font":
            {
                "face": "Ricty Diminished",
                "size": 18
            },
            "opacity": 80,
            "useAcrylic": false
        },
+++
```

## Visual Studio Code

[Visual Studio Code](https://azure.microsoft.com/en-us/products/visual-studio-code/ "Visual Studio Code")

Install Visual Studio Code from Microsoft Store

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

## WSL 2 (Windows Subsystem for Linux 2)

[Windows Subsystem for Linux Documentation](https://docs.microsoft.com/en-us/windows/wsl/ "Windows Subsystem for Linux Documentation")

```powershell
wsl --install -d Debian
```

```zsh
exit (or ctrl + D)
```

```powershell
wsl -l -v
```

```powershell
debian
```

```zsh
cat /etc/os-release
```

```zsh
sudo apt update
sudo apt upgrade
```

```zsh
sudo dpkg-reconfigure locales

ja_JP.UTF-8
```

```zsh
sudo dpkg-reconfigure tzdata

Asia/Tokyo
```

## Docker

[Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/ "Install Docker Engine on Debian")
