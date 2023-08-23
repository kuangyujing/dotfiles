![dotfiles](.assets/logo.png)

## Setup

### (macOS only) Install command line developer tools

```sh
if [ $(uname) == "Darwin" ]; then
    xcode-select --install
fi
```

### Clone dotfiles

```sh
git https://github.com/kuangyujing/dotfiles.git
```


## Homebrew

### Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Backup Packages

```sh
brew bundle dump
```

### Restore Packages

```sh
brew bundle
```

## Basic Setup

### Bash

```sh
cp dotfiles/bash/bashrc ~/.bashrc
```

