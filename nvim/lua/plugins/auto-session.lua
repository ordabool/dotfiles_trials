return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    suppressed_dirs = { '~/', '~/Downloads', '/' },
  },
  keys = {
    { '<leader>R', function()
      vim.cmd('%bdelete')
      vim.cmd('AutoSession save')
    end, desc = 'Reset session (clear buffers)' },
  },
  init = function()
    local timer = vim.uv.new_timer()
    timer:start(60000, 60000, vim.schedule_wrap(function()
      if not vim.g.auto_session_suppressed then
        vim.cmd('silent! AutoSession save')
      end
    end))
  end,
}
