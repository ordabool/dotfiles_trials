vim.opt.number = true
vim.opt.relativenumber = true

vim.g.have_nerd_font = true

vim.opt.breakindent = true
vim.opt.undofile = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'no'

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Disable mouse and popup menu
-- vim.opt.mouse = ''
-- vim.opt.mousemodel = 'extend'

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', extends = '>', precedes = '<', eol = '↴' }

-- Use 4 spaces tab
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 0

-- Automatically detect and handle different line endings
vim.opt.fileformats = { 'unix', 'dos' }

-- Set line endings for files
-- vim.api.nvim_create_autocmd("BufWritePre", {
--    pattern = "*",
--    command = "set binary | set noeol"
-- })

-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "*",
--     command = "set nobinary | set eol"
-- })

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Remove carriage return from windows (CRLF)
vim.keymap.set('n', '<leader>m', function()
  vim.cmd([[%s/\r//g]])
end, { desc = 'Remove trailing CRLF endings' })

-- Format JSON file with jq
vim.keymap.set('n', '<leader>j', function()
  vim.cmd([[%!jq .]])
end, { desc = 'Format JSON file' })

-- Map 'jj' to escape from insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- Clear search highlighting
vim.keymap.set('n', '<leader>/', function()
  vim.cmd('nohlsearch')
end, { desc = 'Clear search highlighting' })

-- Quick buffer switching
vim.keymap.set('n', ',,', '<C-^>', { desc = 'Toggle to last buffer' })

-- Add YACC filetype syntax highlighting
vim.filetype.add({
  pattern = { [".*%.y"] = "yacc" },
})

-- Set terminal colors
vim.opt.termguicolors = true

-- Resize splits using Ctrl + hjkl
vim.api.nvim_set_keymap('n', '<C-h>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':vertical resize +2<CR>', { noremap = true, silent = true })

-- Tmux-style splits (Ctrl+w followed by % or ")
vim.keymap.set('n', '<C-w>%', ':vsplit<CR>', { desc = 'Vertical split (tmux-style)' })
vim.keymap.set('n', '<C-w>"', ':split<CR>', { desc = 'Horizontal split (tmux-style)' })

-- Ctrl+w then Alt+hjkl to move/swap windows
vim.keymap.set('n', '<C-w><M-h>', '<C-w>H', { desc = 'Move window to far left' })
vim.keymap.set('n', '<C-w><M-j>', '<C-w>J', { desc = 'Move window to bottom' })
vim.keymap.set('n', '<C-w><M-k>', '<C-w>K', { desc = 'Move window to top' })
vim.keymap.set('n', '<C-w><M-l>', '<C-w>L', { desc = 'Move window to far right' })

-- Treat Jenkinsfile as groovy
vim.cmd [[
  autocmd BufRead,BufNewFile *Jenkinsfile* set filetype=groovy
]]

-- Auto-reload files when changed externally (e.g., by Claude Code)
vim.opt.autoread = true

-- Trigger checktime on various events to detect external changes
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
})

-- Notify when file is auto-reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File reloaded: " .. vim.fn.expand("%"), vim.log.levels.INFO)
  end,
})
