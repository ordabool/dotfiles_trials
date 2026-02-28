return {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" }, -- ensure cmp is loaded first
    config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({
            disable_filetype = { "neo-tree", "TelescopePrompt" },
        })

        -- Make autopairs aware of cmp: when you confirm a completion that ends
        -- with a function, autopairs will insert the closing paren automatically.
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done)
    end,
}
