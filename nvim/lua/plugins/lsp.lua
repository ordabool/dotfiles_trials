return {
    {
        -- Mason: installs language server binaries
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig", -- provides default server configs (cmd, root markers, etc.)
        },
        config = function()
            -- Keybindings, set only when an LSP attaches to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local buf = event.buf
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = buf, desc = desc })
                    end

                    -- Navigation
                    map("gd", vim.lsp.buf.definition,     "Go to definition")
                    map("gD", vim.lsp.buf.declaration,    "Go to declaration")
                    map("gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("gr", vim.lsp.buf.references,     "Find references")
                    map("K",  vim.lsp.buf.hover,          "Hover documentation")

                    -- Editing
                    map("<leader>rn", vim.lsp.buf.rename,       "Rename symbol")
                    map("<leader>ca", vim.lsp.buf.code_action,  "Code action")
                    map("<leader>F",  vim.lsp.buf.format,       "Format buffer")

                    -- Diagnostics
                    map("<leader>d",  vim.diagnostic.open_float, "Show line diagnostics")
                    map("[d",         vim.diagnostic.goto_prev,  "Previous diagnostic")
                    map("]d",         vim.diagnostic.goto_next,  "Next diagnostic")
                end,
            })

            -- automatic_enable: calls vim.lsp.enable() for each installed server.
            -- nvim-lspconfig (above) supplies the default cmd/root_dir for each.
            -- Works best with a compile_commands.json in the project root:
            --   cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
            --   bear -- make  (wraps any build system)
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
                automatic_enable = true,
            })
        end,
    },
}
