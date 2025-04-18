require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        nix = { "nixfmt" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt", lsp_format = "fallback" },
        sql = { "sql_formatter" },
        html = { "djlint" },
        json = { "jq" },
        typst = { "typstyle" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "yamlfix", "ansible-lint" },
        ["*"] = { "injected" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
    },
    format_after_save = {
        timeout_ms = 500,
        lsp_fallback = true,
        quiet = true,
    },
})

vim.keymap.set("n", "<leader>o", function()
    require("conform").format({
        lsp_fallback = true,
        quiet = true,
    })
end, {
    noremap = true,
    silent = true,
    desc = "Format document",
})
