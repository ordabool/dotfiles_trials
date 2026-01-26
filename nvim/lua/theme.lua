require("tokyonight").setup({
  -- use the night style
  style = "night", -- options: storm, moon, night, day
  -- transparent background
  transparent = true,
  -- enable terminal colors
  terminal_colors = true,
  styles = {
    -- style for comments
    comments = { italic = true },
    -- style for keywords
    keywords = { italic = true },
    -- style for functions
    functions = {},
    -- style for variables
    variables = {},
    -- background styles: dark, transparent, normal
    sidebars = "dark",
    floats = "dark",
  },
  -- adjust specific highlights
  on_highlights = function(hl, c)
    hl.CursorLineNr = { fg = c.orange, bold = true }
    -- GitSigns colors
    hl.GitSignsAdd = { fg = c.green }
    hl.GitSignsChange = { fg = c.yellow }
    hl.GitSignsDelete = { fg = c.red }
    hl.GitSignsUntracked = { fg = c.comment }
  end,
})

vim.cmd[[colorscheme tokyonight]]
