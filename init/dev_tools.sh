#!/usr/bin/env bash

################################################################################
# Development Tools Installation
################################################################################
# Installs programming languages, cloud tools, databases, and development utilities
# Organized by tiers: Core, Developer, Cloud/DevOps, Database
################################################################################

set -e

# Source the dotfiles script for helper functions
DOTFILES_DIR="${HOME}/.dotfiles"
source "${DOTFILES_DIR}/bin/dotfiles"

# Ensure Homebrew is in PATH
if is_macos && [[ -z "$(type -P brew)" ]]; then
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

if is_macos; then
    e_header "Installing Development Tools (macOS)"

    # ========================================
    # CORE TIER - Essential development tools
    # ========================================
    e_arrow "Core Tools"
    brew install git git-lfs
    brew install gh glab               # GitHub & GitLab CLI
    brew install curl wget
    brew install tree

    # ========================================
    # DEVELOPER TIER - Languages & Build Tools
    # ========================================
    e_arrow "Programming Languages"
    brew install go                    # Go 1.25+
    brew install rust                  # Rust with cargo
    brew install python@3.14           # Latest Python
    brew install node@20               # Node.js LTS
    brew install ruby                  # Ruby
    brew install php                   # PHP 8.4+
    brew install lua                   # Lua

    e_arrow "Package Managers & Build Tools"
    brew install mise                  # Modern runtime manager
    brew install composer              # PHP package manager
    brew install yarn                  # Node.js package manager

    e_arrow "Development Utilities"
    brew install direnv                # Environment variable manager
    brew install pre-commit            # Git pre-commit hooks
    brew install cloc                  # Code line counter
    brew install readline              # Terminal line editing
    brew install jq                    # JSON processor

    # ========================================
    # CLOUD/DEVOPS TIER - Infrastructure Tools
    # ========================================
    e_arrow "Cloud Tools - AWS"
    brew install awscli                # AWS CLI v2
    brew install aws-vault             # AWS credential manager
    brew install aws-iam-authenticator # AWS IAM for Kubernetes
    brew install eksctl                # Amazon EKS CLI

    e_arrow "Container Tools"
    brew install podman                # Container engine (Docker alternative)

    e_arrow "Kubernetes Tools"
    brew install kubectl               # Kubernetes CLI
    brew install helm                  # Kubernetes package manager
    brew install k9s                   # Kubernetes TUI
    brew install kubectx               # Context/namespace switcher

    e_arrow "Infrastructure as Code"
    brew install ansible               # Configuration management

    # ========================================
    # DATABASE TIER - Database Tools
    # ========================================
    e_arrow "Database Clients"
    brew install mysql-client          # MySQL client
    brew install postgresql            # PostgreSQL (libpq)
    brew install redis                 # Redis CLI
    brew install sqlite                # SQLite
    brew install duckdb                # DuckDB analytical database
    brew install pgcli                 # PostgreSQL CLI with autocomplete

    # ========================================
    # ADDITIONAL TOOLS
    # ========================================
    e_arrow "Additional Development Tools"
    brew install nmap                  # Network scanner
    brew install gnupg                 # GPG encryption

    # ========================================
    # GUI APPLICATIONS (Optional)
    # ========================================
    e_arrow "Development GUI Applications"
    brew install --cask adoptopenjdk   # Java JDK
    brew install --cask mysqlworkbench # MySQL GUI
    brew install --cask postman        # API testing

    e_arrow "JetBrains IDEs"
    brew install --cask datagrip       # Database IDE
    brew install --cask phpstorm       # PHP IDE
    brew install --cask pycharm        # Python IDE (Professional)
    brew install --cask webstorm       # JavaScript/TypeScript IDE
    brew install --cask goland         # Go IDE

    e_arrow "Code Editors & Notebooks"
    brew install --cask jupyterlab-app # Jupyter notebook environment
    brew install --cask typora         # Markdown editor

    e_success "Development tools installation complete!"

elif is_ubuntu; then
    e_header "Installing Development Tools (Ubuntu)"

    sudo apt-get update

    # ========================================
    # CORE TIER
    # ========================================
    e_arrow "Core Tools"
    sudo apt install -y git curl wget tree

    # ========================================
    # DEVELOPER TIER
    # ========================================
    e_arrow "Development Tools via Homebrew"
    brew install go
    brew install rust
    brew install node
    brew install typescript
    brew install python@3.14
    brew install composer
    brew install mise
    brew install direnv
    brew install pre-commit
    brew install cloc
    brew install jq

    # ========================================
    # CLOUD/DEVOPS TIER
    # ========================================
    e_arrow "Cloud & Infrastructure Tools"
    sudo apt install -y vpnc
    brew install terraform terragrunt terraform_landscape
    brew install aws-iam-authenticator
    brew install awscli
    brew install eksctl

    e_arrow "Ansible"
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible

    e_arrow "Container Tools"
    sudo addgroup --system docker || true
    sudo adduser $USER docker || true
    sudo snap install docker
    newgrp docker || true
    sudo snap restart docker
    brew install docker-completion docker-compose docker-compose-completion

    e_arrow "Kubernetes Tools"
    brew install kubectl eksctl k9s helm kubectx

    # ========================================
    # DATABASE TIER
    # ========================================
    e_arrow "Database Tools"
    brew install mysql-client
    brew install redis
    brew install sqlite
    brew install duckdb

    e_success "Development tools installation complete!"
fi
