return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup({
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged_enable = false,
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Navigation between hunks
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer=bufnr, desc='Next git change'})

        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true, buffer=bufnr, desc='Previous git change'})

        -- Actions
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer=bufnr, desc='Preview git hunk'})
        vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {buffer=bufnr, desc='Git blame line'})
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer=bufnr, desc='Stage hunk'})
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer=bufnr, desc='Reset hunk'})
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {buffer=bufnr, desc='Undo stage hunk'})
        vim.keymap.set('n', '<leader>hd', gs.diffthis, {buffer=bufnr, desc='Diff this file'})
        vim.keymap.set('n', '<leader>hD', function()
          local current_buf = vim.api.nvim_get_current_buf()
          -- Turn off diff mode
          vim.cmd('diffoff!')
          -- Find and close gitsigns diff buffers (temporary buffers)
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local bufname = vim.api.nvim_buf_get_name(buf)
            -- Close windows showing gitsigns diff (temp buffers start with fugitive or gitsigns)
            if bufname:match('^gitsigns://') or (buf ~= current_buf and vim.bo[buf].buftype == 'nofile') then
              vim.api.nvim_win_close(win, true)
            end
          end
        end, {buffer=bufnr, desc='Close diff'})
      end
    })
  end
}
