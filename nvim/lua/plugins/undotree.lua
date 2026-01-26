return {
  'mbbill/undotree',
  config = function()
    -- Toggle undotree
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree' })

    -- Undotree window configuration
    vim.g.undotree_WindowLayout = 2  -- Layout: tree on left, diff on bottom
    vim.g.undotree_SetFocusWhenToggle = 1  -- Focus undotree when opened
    vim.g.undotree_ShortIndicators = 1  -- Use short time indicators
    vim.g.undotree_DiffAutoOpen = 1  -- Auto open diff window
  end
}
