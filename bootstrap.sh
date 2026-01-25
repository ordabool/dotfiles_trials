#!/usr/bin/env bash

set -e  # Exit on error

# Determine if we need sudo
if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            OS_VERSION=$VERSION_ID
        else
            log_error "Cannot detect Linux distribution"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        log_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
    log_info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install packages based on OS
install_packages() {
    log_info "Installing system packages..."

    local packages="git curl wget tmux zsh fzf ripgrep jq xclip build-essential"

    case $OS in
        ubuntu|debian|pop)
            $SUDO apt-get update
            $SUDO apt-get install -y $packages
            ;;
        fedora|rhel|centos)
            $SUDO dnf install -y $packages
            ;;
        arch|manjaro)
            $SUDO pacman -Sy --noconfirm $packages
            ;;
        macos)
            if ! command_exists brew; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install $packages
            ;;
        *)
            log_error "Unsupported OS for automatic package installation: $OS"
            exit 1
            ;;
    esac

    log_success "System packages installed"
}

# Install Node.js (v20+)
install_nodejs() {
    if command_exists node; then
        NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_VERSION" -ge 20 ]; then
            log_success "Node.js v$NODE_VERSION already installed (>= v20)"
            return
        fi
    fi

    log_info "Installing Node.js v20..."

    case $OS in
        ubuntu|debian|pop)
            curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO -E bash -
            $SUDO apt-get install -y nodejs
            ;;
        fedora|rhel|centos)
            curl -fsSL https://rpm.nodesource.com/setup_20.x | $SUDO bash -
            $SUDO dnf install -y nodejs
            ;;
        arch|manjaro)
            $SUDO pacman -S --noconfirm nodejs npm
            ;;
        macos)
            brew install node@20
            ;;
    esac

    log_success "Node.js installed: $(node --version)"
}

# Install Neovim (latest version from binary)
install_neovim() {
    if [ -f /opt/nvim-linux-x86_64/bin/nvim ]; then
        log_success "Neovim already installed at /opt/nvim-linux-x86_64/bin/nvim"
        return
    fi

    log_info "Installing Neovim (latest stable)..."

    if [[ "$OS" == "macos" ]]; then
        brew install neovim
    else
        # Download latest Neovim binary
        cd /tmp
        wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        $SUDO tar -xzf nvim-linux64.tar.gz -C /opt
        $SUDO mv /opt/nvim-linux64 /opt/nvim-linux-x86_64
        rm nvim-linux64.tar.gz
    fi

    log_success "Neovim installed: $(/opt/nvim-linux-x86_64/bin/nvim --version | head -n1)"
}

# Install luarocks
install_luarocks() {
    if command_exists luarocks; then
        log_success "luarocks already installed"
        return
    fi

    log_info "Installing luarocks..."

    case $OS in
        ubuntu|debian|pop)
$SUDO apt-get install -y luarocks
            ;;
        fedora|rhel|centos)
$SUDO dnf install -y luarocks
            ;;
        arch|manjaro)
$SUDO pacman -S --noconfirm luarocks
            ;;
        macos)
            brew install luarocks
            ;;
    esac

    log_success "luarocks installed"
}

# Install Claude Code
install_claude_code() {
    if command_exists claude; then
        log_success "Claude Code already installed"
        return
    fi

    log_info "Installing Claude Code..."

    if [[ "$OS" == "macos" ]]; then
        brew install claude
    else
        # Install via npm globally
$SUDO npm install -g @anthropic-ai/claude-code
    fi

    log_success "Claude Code installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_success "Oh My Zsh already installed"
        return
    fi

    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    log_success "Oh My Zsh installed"
}

# Install Powerlevel10k
install_powerlevel10k() {
    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    if [ -d "$P10K_DIR" ]; then
        log_success "Powerlevel10k already installed"
        return
    fi

    log_info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"

    log_success "Powerlevel10k installed"
}

# Install Nerd Font
install_nerd_font() {
    log_info "Checking for Nerd Fonts..."

    if [[ "$OS" == "macos" ]]; then
        brew tap homebrew/cask-fonts
        brew install --cask font-dejavu-sans-mono-nerd-font
        log_success "DejaVuSansM Nerd Font installed via Homebrew"
    else
        local FONT_DIR="$HOME/.local/share/fonts"
        local FONT_FILE="$FONT_DIR/DejaVuSansMNerdFont-Regular.ttf"

        if [ -f "$FONT_FILE" ]; then
            log_success "Nerd Font already installed"
            return
        fi

        log_info "Installing DejaVuSansM Nerd Font..."
        mkdir -p "$FONT_DIR"
        cd /tmp
        wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DejaVuSansMono.zip
        unzip -o DejaVuSansMono.zip -d "$FONT_DIR"
        rm DejaVuSansMono.zip
        fc-cache -fv

        log_success "Nerd Font installed"
        log_warning "Set your terminal to use 'DejaVuSansM Nerd Font' for best experience"
    fi
}

# Clone dotfiles repo
clone_dotfiles() {
    if [ -d "$HOME/.dotfiles/.git" ]; then
        log_success "Dotfiles repo already exists"
        return
    fi

    log_info "Cloning dotfiles repository..."

    if [ -d "$HOME/.dotfiles" ]; then
        log_warning "~/.dotfiles exists but is not a git repo. Backing up to ~/.dotfiles.backup"
        mv "$HOME/.dotfiles" "$HOME/.dotfiles.backup"
    fi

    # Replace with your actual GitHub repo URL
    git clone https://github.com/ordabool/dotfiles_trials.git "$HOME/.dotfiles"

    log_success "Dotfiles cloned"
}

# Create symlinks
create_symlinks() {
    log_info "Creating symlinks..."

    local dotfiles=(
        ".zshrc"
        ".bashrc"
        ".tmux.conf"
        ".p10k.zsh"
    )

    for dotfile in "${dotfiles[@]}"; do
        local source="$HOME/.dotfiles/$dotfile"
        local target="$HOME/$dotfile"

        if [ -L "$target" ]; then
            log_success "Symlink already exists: $dotfile"
            continue
        fi

        if [ -f "$target" ]; then
            log_warning "Backing up existing $dotfile to ${dotfile}.backup"
            mv "$target" "${target}.backup"
        fi

        ln -s "$source" "$target"
        log_success "Created symlink: $dotfile"
    done

    # Symlink nvim config
    local nvim_source="$HOME/.dotfiles/nvim"
    local nvim_target="$HOME/.config/nvim"

    if [ -L "$nvim_target" ]; then
        log_success "Neovim config symlink already exists"
    else
        mkdir -p "$HOME/.config"
        if [ -d "$nvim_target" ]; then
            log_warning "Backing up existing nvim config to ~/.config/nvim.backup"
            mv "$nvim_target" "$nvim_target.backup"
        fi
        ln -s "$nvim_source" "$nvim_target"
        log_success "Created symlink: nvim config"
    fi
}

# Set zsh as default shell
set_default_shell() {
    if [ "$SHELL" = "$(which zsh)" ]; then
        log_success "Zsh is already the default shell"
        return
    fi

    log_info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"

    log_success "Default shell changed to zsh (restart terminal to apply)"
}

# Main installation flow
main() {
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║     Development Environment Bootstrap Script         ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    log_info "Starting bootstrap process..."
    echo

    detect_os
    install_packages
    install_nodejs
    install_neovim
    install_luarocks
    install_claude_code
    install_oh_my_zsh
    install_powerlevel10k
    install_nerd_font

    # Only clone if not running from within .dotfiles directory
    if [ "$(pwd)" != "$HOME/.dotfiles" ]; then
        clone_dotfiles
    fi

    create_symlinks
    set_default_shell

    echo
    echo -e "${GREEN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║            ✓ Bootstrap Complete!                     ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    log_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Configure Powerlevel10k: p10k configure"
    echo "  3. Open neovim - plugins will auto-install: nvim"
    echo "  4. Set up Claude Code: claude"
    echo "  5. Make sure your terminal uses 'DejaVuSansM Nerd Font'"
    echo "  6. (Optional) Create ~/.zshrc.local for machine-specific aliases/config"
    echo
    log_warning "If you want to use zsh immediately, run: zsh"
}

# Run main function
main "$@"
