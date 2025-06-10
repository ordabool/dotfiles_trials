return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup {
      ---Add keybindings
      mappings = {
        basic = true,
        extra = true,
        extended = false,
      },
    }

    -- Keybinding for commenting
    vim.keymap.set("n", "<leader>c", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", { noremap = true, silent = true })
    vim.keymap.set("x", "<leader>c", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { noremap = true, silent = true })
  end,
}
