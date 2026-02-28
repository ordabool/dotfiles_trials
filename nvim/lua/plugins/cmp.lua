return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",   -- LSP completions
            "hrsh7th/cmp-buffer",     -- words from current buffer
            "hrsh7th/cmp-path",       -- filesystem paths
            "L3MON4D3/LuaSnip",       -- snippet engine
            "saadparwaiz1/cmp_luasnip", -- connect luasnip to cmp
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    -- Navigate completion menu
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    -- Scroll docs popup
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),

                    -- Confirm selection
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),

                    -- Tab: confirm if menu open, else expand snippet or insert tab
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Manually trigger completion
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Close the menu
                    ["<C-e>"] = cmp.mapping.abort(),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- highest priority: LSP
                    { name = "luasnip" },  -- snippets
                }, {
                    { name = "buffer" },   -- fallback: buffer words
                    { name = "path" },     -- filesystem paths
                }),
            })
        end,
    },
}
