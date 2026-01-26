return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    -- Setup telescope with global exclusions
    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          "node_modules/",
          ".git/",
          "%.git/",
          "build/",
          "dist/",
          "target/",
          "%.class$",
          "%.o$",
          "%.pyc$",
          "__pycache__/",
          ".pytest_cache/",
          ".venv/",
          "venv/",
        }
      }
    })

    -- Default: show hidden files, respect .gitignore
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({ hidden = true })
    end, { desc = 'Telescope find files' })

    -- Show ALL files including gitignored (but still exclude patterns above)
    vim.keymap.set('n', '<leader>fF', function()
      builtin.find_files({
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true
      })
    end, { desc = 'Telescope find ALL files (including gitignored)' })

    -- Default grep: search hidden files, respect .gitignore
    vim.keymap.set('n', '<leader>fg', function()
      builtin.live_grep({
        additional_args = function(opts)
          return {"--hidden"}
        end
      })
    end, { desc = 'Telescope live grep' })

    -- Grep everything including gitignored
    vim.keymap.set('n', '<leader>fG', function()
      builtin.live_grep({
        additional_args = function(opts)
          return {"--hidden", "--no-ignore"}
        end
      })
    end, { desc = 'Telescope live grep ALL files' })

    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
  end
}
