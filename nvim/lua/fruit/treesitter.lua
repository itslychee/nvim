-- require("ts_context_commentstring").setup({
--     enable_autocmd = false,
-- })
-- is this even needed?
success, val = pcall(require, "nvim-treesitter.configs")
if success then
    val.setup({
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        -- WHY?:
        -- Indention is funky for Nix when using `o` after a new element
        -- e.g.
        -- mkShell {
        --  packages = [
        --     b
        --               ^[cursor here]
        --  ]
        -- }
        --
        -- Sources (for me): https://discord.com/channels/1209971237770498088/1209971238349443144/1302388898428878869
        --
        -- indent = { enable = true },
        -- is shorthand for
        -- vim.bo.indentexpr = "nvim_treesitter#indent()"
        -- use for specific ftplugins if desired
        --
        --Source:
        --https://github.com/nvim-treesitter/nvim-treesitter/issues/6723#issuecomment-2151597595
    })
end
