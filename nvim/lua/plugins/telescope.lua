return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fF', function() builtin.find_files({ hidden = true }) end, { desc = 'Telescope find files including hidden' })
    vim.keymap.set('n', '<leader>fG', function() 
        builtin.live_grep({
            additional_args = function(opts)
                return {"--hidden"}
            end
        }) 
    end, { desc = 'Telescope live grep including hidden' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
  end
}
