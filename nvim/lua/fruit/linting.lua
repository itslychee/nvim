local lint = require("lint")

lint.linters_by_ft = {
    python = { "ruff" },
    bash = { "bash" },
    rust = { "clippy" },
    nix = { "nix", "deadnix", "statix" },
    html = { "djlint" },
    javascript = { "eslint" },
    typescript = { "eslint" },
    json = { "yq", "jsonlint" },
    markdown = { "markdownlint", "vale" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        lint.try_lint()
    end,
})
