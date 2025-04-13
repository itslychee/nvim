local api = vim.api
local lspconfig = require("lspconfig")
local k = vim.keymap.set

local LSPs = {
    "ccls",
    "nil_ls",
    "gopls",
    "pyright",
    "tinymist",
    "ruff",
    "ts_ls",
    "eslint",
    "rust_analyzer",
}
local caps = require("cmp_nvim_lsp").default_capabilities()
-- local caps = require("blink.cmp").get_lsp_capabilities()

for _, server in ipairs(LSPs) do
    lspconfig[server].setup({
        capabilities = caps,
    })
end

vim.diagnostic.config({
    virtual_text = {},
    severity_sort = true,
    underline = true,
})

-- LSP setup
api.nvim_create_autocmd("LspAttach", {
    group = api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local bufnr = ev.buf
        vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"
        if client ~= nil then
            if client:supports_method("textDocument/completion", bufnr) then
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end
            if client:supports_method("textDocument/definition", bufnr) then
                vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
            end
        end

        -- Disable inlay hints as they're a little bit too noisy
        --
        -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

        ---@diagnostic disable-next-line: lowercase-global
        function lsp(kmType, keymap, func, description)
            k("n", keymap, func, {
                buffer = ev.buf,
                desc = "[" .. kmType .. "] " .. description,
            })
        end
        lsp("LSP", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        lsp("LSP", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        lsp("LSP", "gd", vim.lsp.buf.declaration, "Goto declaration")
        lsp("LSP", "gD", vim.lsp.buf.definition, "Goto definition")
        lsp("LSP", "gr", vim.lsp.buf.references, "See references")
        lsp("LSP", "gi", vim.lsp.buf.implementation, "Goto implementation")

        -- Diagnostics
        lsp("Diagnostics", "<leader>s", vim.diagnostic.setloclist, "Overview")
        lsp("Diagnostics", "<leader>a", vim.diagnostic.open_float, "Expand error")
        -- deprecated,
        -- lsp("Diagnostics", "<leader>e", vim.diagnostic.goto_prev, "Go to previous error")
        -- lsp("Diagnostics", "<leader>i", vim.diagnostic.goto_next, "Go to next error")
    end,
})
require("typescript-tools").setup({
    capabilities = caps,
    cmd = {
        "typescript-language-server",
        "--stdio",
    },
    settings = {
        tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
        },
        tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
        },
    },
})

-- I hate guessing
require("lspconfig").lua_ls.setup({
    capabilities = caps,
    on_init = function(client)
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        })
    end,
    settings = {
        Lua = {},
    },
})
