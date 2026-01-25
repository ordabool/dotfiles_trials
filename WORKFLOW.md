# tmux + vim + Claude Code Workflow

This guide shows you how to use tmux, neovim, and Claude Code together for agentic development.

## The Setup

### Recommended Layout: Vertical Split

```
┌─────────────────────────┬──────────────────────┐
│                         │                      │
│   Neovim (left 60%)     │  Claude Code (40%)   │
│                         │                      │
│   - Code editing        │  - AI assistant      │
│   - Quick changes       │  - Refactoring       │
│   - Code exploration    │  - Testing           │
│   - Manual control      │  - Git ops           │
│                         │                      │
└─────────────────────────┴──────────────────────┘
```

### Starting Your Session

```bash
# Create a new tmux session
tmux new -s dev

# Split vertically (creates right pane)
Ctrl+a %

# Or use the custom binding (if you add it)
Ctrl+a |

# Resize panes
Ctrl+a Ctrl+h/l  # Make left/right panes bigger/smaller

# Navigate between panes
Ctrl+a h  # Go to left pane
Ctrl+a l  # Go to right pane

# Left pane: Start neovim
nvim .

# Right pane: Start Claude Code
claude
```

## Key Bindings Cheat Sheet

### Tmux (Prefix: Ctrl+a)

| Key | Action |
|-----|--------|
| `Ctrl+a %` | Split vertically |
| `Ctrl+a "` | Split horizontally |
| `Ctrl+a h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+a Ctrl+h/j/k/l` | Resize panes |
| `Ctrl+a z` | Zoom/unzoom current pane |
| `Ctrl+a d` | Detach from session |
| `Ctrl+a c` | Create new window |
| `Ctrl+a n/p` | Next/previous window |
| `Ctrl+a ?` | Show all keybindings |

### Neovim (Leader: `,`)

#### File Navigation
- `,e` - Toggle file tree (Neo-tree)
- `,ff` - Find files (Telescope)
- `,fg` - Live grep (search in files)
- `,fF` - Find files (including hidden)
- `,fG` - Live grep (including hidden)
- `,fb` - Browse open buffers
- `,fh` - Search help tags

#### Editing
- `,c` - Toggle comment (normal/visual mode)
- `,m` - Remove CRLF line endings
- `,j` - Format JSON with jq
- `,/` - Clear search highlighting
- `jj` - Escape from insert mode

#### Window Management
- `Ctrl+h/l` - Resize splits horizontally
- `Ctrl+j/k` - Resize splits vertically

## Daily Workflow Examples

### 1. Starting a New Feature

```bash
# Morning: Start your session
tmux new -s feature-x
Ctrl+a %  # Split for Claude

# Left pane (nvim):
,e              # Open file tree
,ff auth        # Find auth-related files

# Right pane (claude):
> Help me understand the authentication flow in this codebase

# Claude explores and explains
# You read along in vim
```

### 2. Implementing Changes

**Let Claude handle complex multi-file refactoring:**

```
# In Claude pane:
> Refactor the authentication to use JWT tokens instead of sessions

# Watch Claude:
# - Read existing code
# - Make changes across multiple files
# - Run tests

# In vim pane:
# Files auto-reload as Claude edits them
# Review changes in real-time
# Make quick tweaks if needed
```

### 3. Bug Investigation

```
# In vim:
,fg "error connecting"  # Search for error messages

# In Claude:
> There's a connection error in database.ts:142, can you investigate?

# Claude will:
# - Read the problematic code
# - Check related files
# - Suggest fixes
# - Run tests
```

### 4. Quick Manual Edits

```
# Sometimes you just need a quick change:
# Use vim for instant, direct edits
# No need to ask Claude for one-line changes

# In vim:
,e                  # Open file tree
# Navigate and edit
:w                  # Save

# In Claude:
> Run the tests to make sure my change works
```

### 5. Code Review Before Commit

```
# In vim:
# Review files with gitsigns indicators
# Left side shows +/- for changes

# In Claude:
> Review the changes and create a commit if they look good

# Claude will:
# - Run git diff
# - Check for issues
# - Create a commit with good message
```

### 6. End of Day

```bash
# Save your work
Ctrl+a d  # Detach from tmux session

# Next morning: Resume right where you left off
tmux attach -t feature-x

# Everything is exactly as you left it!
```

## Pro Tips

### Auto-reload in Vim
Your nvim is configured to automatically reload files when Claude edits them. If it doesn't update:
- Switch to the Claude pane and back (`Ctrl+a l`, `Ctrl+a h`)
- Or manually reload: `:e!`

### When to Use Claude vs Vim

**Use Claude for:**
- Multi-file refactoring
- Understanding unfamiliar code
- Writing new features from scratch
- Running tests and CI/CD tasks
- Git operations (commits, PRs)
- Complex regex or data transformations

**Use Vim for:**
- Quick one-line edits
- Exploring code structure (with telescope/neo-tree)
- Fine-tuning Claude's changes
- Reading and navigating code
- Split-window code comparison

### Zooming
- `Ctrl+a z` temporarily maximizes the current pane
- Great for focusing on either Claude or vim
- Press again to restore layout

### Mouse Support
Your tmux has mouse support enabled:
- Click to switch panes
- Drag borders to resize
- Scroll in panes

But keyboard navigation is faster once you learn it!

### Session Management

```bash
# List sessions
tmux ls

# Attach to existing session
tmux attach -t dev

# Kill a session
tmux kill-session -t dev

# Create named session with specific layout
tmux new -s project
Ctrl+a %
# Set up your panes
# Then detach - layout is saved
```

### Custom Keybindings (Optional)

Add these to your `.tmux.conf` for even better workflow:

```bash
# Alt+arrow keys to switch panes without prefix
bind -n M-h select-pane -L
bind -n M-l select-pane -R
bind -n M-j select-pane -D
bind -n M-k select-pane -U

# Better split commands that preserve current path
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
```

## Example Full Session

```bash
# 1. Start
tmux new -s myproject
Ctrl+a %

# 2. Setup
# Left: nvim .
# Right: claude

# 3. Work
# Vim: ,e (explore code)
# Claude: "Add user profile endpoint with tests"

# 4. Review changes in vim as Claude works
# Files auto-reload

# 5. Make manual tweaks in vim
# Quick fixes, formatting, etc.

# 6. Continue
# Claude: "Run the tests"
# Claude: "Create a commit"

# 7. End of day
Ctrl+a d

# 8. Next day
tmux attach -t myproject
# Continue exactly where you left off!
```

## Troubleshooting

**File not reloading in vim?**
- Switch panes: `Ctrl+a h` then `Ctrl+a l`
- Or `:checktime` in vim

**Tmux prefix not working?**
- Remember it's `Ctrl+a`, not `Ctrl+b`
- Test with `Ctrl+a ?`

**Pane too small?**
- `Ctrl+a Ctrl+h/j/k/l` to resize
- Or `Ctrl+a z` to zoom temporarily

**Lost in nested vim/tmux?**
- `Ctrl+a d` detaches from tmux
- `:qa` quits all vim buffers
- When confused: `Ctrl+a z` to zoom current pane

## Philosophy

This setup gives you the best of both worlds:

1. **Silent, focused editor** (vim) - No AI noise, just you and the code
2. **Powerful AI assistant** (Claude Code) - Complex tasks, understanding, automation
3. **Persistent workspace** (tmux) - Never lose context, pick up where you left off

The key is using the right tool for each task. Vim for control and speed, Claude for intelligence and automation, tmux for organization and persistence.

Happy coding! 🚀
