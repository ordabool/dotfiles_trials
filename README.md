# My Dotfiles

Development environment configuration for tmux + neovim + zsh + Claude Code.

## Quick Setup (New Machine)

Run this one-liner to bootstrap your development environment:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ordabool/dotfiles_trials/main/bootstrap.sh)
```

Or clone first and run locally:

```bash
git clone https://github.com/ordabool/dotfiles_trials.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

The script will install:
- Git, tmux, zsh, fzf, ripgrep, jq, xclip
- Neovim (latest stable from binary)
- Node.js v20+
- Claude Code CLI
- Oh My Zsh + Powerlevel10k theme
- DejaVuSansM Nerd Font
- All dotfile configurations (with backups of existing files)

## What's Included

- **Neovim**: Lua-based config with Lazy.nvim plugin manager
  - Tokyo Night theme
  - Telescope (fuzzy finder)
  - Neo-tree (file explorer)
  - Treesitter (syntax highlighting)
  - LSP-ready configuration
  - Auto-reload for external changes
- **Tmux**: Vim-like keybindings, Ctrl+a prefix, mouse support
- **Zsh**: Oh My Zsh + Powerlevel10k prompt
- **Workflow**: Optimized for tmux + vim + Claude Code side-by-side

## Manual Steps (Already Automated Above)
- Install nvim - install from binary for latest version
- Config dotfile (like .vimrc) for global clipboard, line num, etc (?)
- Install Lazy - https://github.com/folke/lazy.nvim (?)
- Install file tree plugin (?)
- Comfortable git integration (?)
- Set up with copilot or some other AI model (?)
- Install `ripgrep`
- Install `jq`
- Install powerlevel10k - https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#manual & nerd font (I use DejaVuSansM Nerd Font)
- Install `tmux`
- Install luarocks - https://github.com/luarocks/luarocks/blob/main/docs/installation_instructions_for_unix.md
- Install nodejs (v20 or newer)
- Install `fzf` through package manager
- Install `xclip`


Good `init.lua` to reference: https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

Consider using oil.nvim - https://github.com/stevearc/oil.nvim

Lua quick reference: https://learnxinyminutes.com/lua/

For treesitter, see here how to add parsers:
https://github.com/nvim-treesitter/nvim-treesitter/#adding-parsers

Create ansible script for creating dev env
