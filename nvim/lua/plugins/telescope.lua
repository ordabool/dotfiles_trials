return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')
    -- Show hidden files by default
    vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ hidden = true }) end, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', function()
        builtin.live_grep({
            additional_args = function(opts)
                return {"--hidden"}
            end
        })
    end, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
  end
}
