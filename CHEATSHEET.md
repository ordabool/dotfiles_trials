# Cheatsheet

Quick reference for all keybindings, aliases, and shortcuts.

## Table of Contents
- [Shell Aliases](#shell-aliases)
- [Tmux](#tmux)
- [Neovim - General](#neovim---general)
- [Neovim - File Navigation](#neovim---file-navigation)
- [Neovim - Window Management](#neovim---window-management)
- [Neovim - Git Integration](#neovim---git-integration)
- [Neovim - Undo History](#neovim---undo-history)
- [Neovim - LSP](#neovim---lsp)
- [Neovim - Utilities](#neovim---utilities)

---

## Shell Aliases

### Tmux Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `t` | `tmux` | Start tmux |
| `ta` | `tmux attach` | Attach to last session |
| `tl` | `tmux list-sessions` | List all tmux sessions |
| `ts <name>` | `tmux new-session -s <name>` | Create named session |
| `trl` | `tmux source-file ~/.tmux.conf` | Reload tmux config |

### Editor Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `vim` | `nvim` | Use neovim instead of vim |
| `vi` | `nvim` | Use neovim instead of vi |

### Shell Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `reload` | `source ~/.zshrc` | Reload zsh configuration |

---

## Tmux

**Prefix Key:** `Ctrl+a`

### Pane Navigation
| Keybinding | Action |
|------------|--------|
| `Ctrl+a h` | Move to left pane |
| `Ctrl+a j` | Move to down pane |
| `Ctrl+a k` | Move to up pane |
| `Ctrl+a l` | Move to right pane |

### Pane Resizing
| Keybinding | Action |
|------------|--------|
| `Ctrl+a C-h` | Resize left (hold Ctrl, repeat) |
| `Ctrl+a C-j` | Resize down (hold Ctrl, repeat) |
| `Ctrl+a C-k` | Resize up (hold Ctrl, repeat) |
| `Ctrl+a C-l` | Resize right (hold Ctrl, repeat) |
| `Ctrl+a H` | Resize left by 10 (repeat) |
| `Ctrl+a J` | Resize down by 10 (repeat) |
| `Ctrl+a K` | Resize up by 10 (repeat) |
| `Ctrl+a L` | Resize right by 10 (repeat) |

### Pane Swapping
| Keybinding | Action |
|------------|--------|
| `Ctrl+a Alt+h` | Swap with left pane |
| `Ctrl+a Alt+j` | Swap with pane below |
| `Ctrl+a Alt+k` | Swap with pane above |
| `Ctrl+a Alt+l` | Swap with right pane |

### Pane Splitting
| Keybinding | Action |
|------------|--------|
| `Ctrl+a %` | Split vertically (tmux-style) |
| `Ctrl+a "` | Split horizontally (tmux-style) |

### Window Management
| Keybinding | Action |
|------------|--------|
| `Ctrl+a c` | Create new window |
| `Ctrl+a [0-9]` | Switch to window N |
| `Ctrl+a ,` | Rename current window |
| `Ctrl+a x` | Close current pane |

---

## Neovim - General

**Leader Key:** `,`

### Basic Navigation
| Keybinding | Action |
|------------|--------|
| `jj` | Exit insert mode (alternative to Esc) |
| `,,` | Toggle to last buffer (quick file switch) |
| `,/` | Clear search highlighting |

### Telescope (Fuzzy Finder)
| Keybinding | Action |
|------------|--------|
| `,ff` | Find files (shows dotfiles, respects .gitignore) |
| `,fF` | Find ALL files (includes gitignored files) |
| `,fg` | Live grep (search in files) |
| `,fG` | Live grep ALL (includes gitignored files) |
| `,fb` | Browse open buffers |
| `,fh` | Search help tags |

**Note:** Telescope excludes `node_modules/`, `.git/`, `build/`, `dist/`, and other build artifacts even with `,fF`.

---

## Neovim - File Navigation

### Neo-tree (File Explorer)
| Keybinding | Action |
|------------|--------|
| `,e` | Toggle Neo-tree (open/close file tree) |
| `,E` | Reveal current file in Neo-tree |

**Inside Neo-tree:**
- `hjkl` - Navigate
- `Enter` - Open file
- `a` - Add file/directory
- `d` - Delete
- `r` - Rename
- `y` - Copy
- `x` - Cut
- `p` - Paste
- `q` - Close Neo-tree

---

## Neovim - Window Management

### Window Splitting
| Keybinding | Action |
|------------|--------|
| `Ctrl+w %` | Split vertically (tmux-style) |
| `Ctrl+w "` | Split horizontally (tmux-style) |
| `:vsp` | Vertical split (vim-style) |
| `:sp` | Horizontal split (vim-style) |

### Window Navigation
| Keybinding | Action |
|------------|--------|
| `Ctrl+w h` | Move to left window |
| `Ctrl+w j` | Move to bottom window |
| `Ctrl+w k` | Move to top window |
| `Ctrl+w l` | Move to right window |

### Window Resizing
| Keybinding | Action |
|------------|--------|
| `Ctrl+h` | Decrease width |
| `Ctrl+j` | Increase height |
| `Ctrl+k` | Decrease height |
| `Ctrl+l` | Increase width |

### Window Movement/Swapping
| Keybinding | Action |
|------------|--------|
| `Ctrl+w Alt+h` | Move window to far left |
| `Ctrl+w Alt+j` | Move window to bottom |
| `Ctrl+w Alt+k` | Move window to top |
| `Ctrl+w Alt+l` | Move window to far right |
| `Ctrl+w c` | Close current window |
| `Ctrl+w o` | Close all other windows (keep current) |

---

## Neovim - Git Integration

### GitSigns (Change Navigation)
| Keybinding | Action |
|------------|--------|
| `]c` | Jump to next git change |
| `[c` | Jump to previous git change |

### Git Actions
| Keybinding | Action |
|------------|--------|
| `,hp` | Preview git hunk (floating window) |
| `,hb` | Show git blame for current line |
| `,hs` | Stage hunk (stage this change) |
| `,hr` | Reset hunk (discard this change) |
| `,hu` | Undo stage hunk |
| `,hd` | Open diff view for current file |
| `,hD` | Close diff view |

**Git Change Indicators (in left gutter):**
- `│` Green - Added lines
- `│` Yellow - Modified lines
- `_` Red - Deleted lines
- `┆` Gray - Untracked files

---

## Neovim - Undo History

### Undotree
| Keybinding | Action |
|------------|--------|
| `,u` | Toggle undotree visualization |

**Inside Undotree:**
- `hjkl` - Navigate through undo history tree
- `Enter` - Go to selected state
- `q` - Close undotree

**Undotree shows:**
- Visual tree of all your edits (including undone branches)
- Timestamps for each change
- Diff preview of changes
- Never lose work - access any previous state!

---

## Neovim - LSP

Keybindings are active only in buffers where a language server has attached (e.g. `.c`, `.cpp` files with clangd).

### Navigation
| Keybinding | Action |
|------------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find all references |
| `K` | Hover documentation (press again to enter float) |
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |

### Editing
| Keybinding | Action |
|------------|--------|
| `,rn` | Rename symbol under cursor |
| `,ca` | Code action (fixes, refactors suggested by LSP) |
| `,F` | Format buffer |
| `,d` | Show diagnostics for current line |

### Autocomplete (insert mode)
| Keybinding | Action |
|------------|--------|
| `Ctrl+n` / `Ctrl+p` | Navigate completion menu |
| `Tab` / `Shift+Tab` | Navigate menu (or jump snippet fields) |
| `Enter` | Confirm selected completion |
| `Ctrl+Space` | Manually trigger completion |
| `Ctrl+d` / `Ctrl+u` | Scroll docs popup |
| `Ctrl+e` | Close completion menu |

**Notes:**
- Completions are sourced from: LSP → snippets → buffer words → file paths
- For best results in larger projects, add `compile_commands.json` to the project root
  - CMake: `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
  - Any build system: `bear -- make`

---

## Neovim - Utilities

### File Operations
| Keybinding | Action |
|------------|--------|
| `,m` | Remove Windows CRLF line endings |
| `,j` | Format JSON file with jq |

### Built-in Vim Commands
| Command | Action |
|---------|--------|
| `:w` | Save file |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `/text` | Search for "text" |
| `n` | Next search result |
| `N` | Previous search result |
| `dd` | Delete line |
| `yy` | Yank (copy) line |
| `p` | Paste |
| `v` | Visual mode |
| `V` | Visual line mode |
| `Ctrl+v` | Visual block mode |

---

## Tips & Workflows

### Quick File Switching
1. `,ff` - Find file by name
2. Edit file
3. `,,` - Jump back to previous file
4. Repeat as needed

### Git Workflow
1. Make changes (see yellow/green bars in gutter)
2. `]c` to jump to each change
3. `,hp` to preview what changed
4. `,hs` to stage or `,hr` to discard
5. Use git in terminal for commit/push

### Undo Tree Power
1. Write code version A
2. Undo and try version B
3. `,u` to open undotree
4. Navigate to version A in tree
5. Now you have both versions accessible!

### Pane Organization
1. Start in one tmux pane with vim
2. `Ctrl+a %` - Split for terminal
3. `Ctrl+a "` - Split terminal horizontally
4. `Ctrl+a h/j/k/l` - Navigate between panes
5. `Ctrl+a H/J/K/L` - Quick resize with big jumps

---

## Configuration Files

- **Tmux:** `~/.tmux.conf`
- **Neovim:** `~/.config/nvim/`
  - Main config: `init.lua`
  - Settings: `lua/settings.lua`
  - Plugins: `lua/plugins/*.lua`
- **Zsh:** `~/.zshrc`
- **Powerlevel10k:** `~/.p10k.zsh`
