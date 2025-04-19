-- local blink = require("blink.cmp")
--
-- blink.setup({
--     cmdline = {
--         enabled = true,
--         completion = {
--             menu = {
--                 auto_show = true,
--             },
--         },
--     },
--     completion = {
--         menu = { auto_show = true },
--         list = {
--             selection = {
--                 preselect = false,
--                 auto_insert = true,
--             },
--         },
--         documentation = {
--             auto_show = true,
--             auto_show_delay_ms = 0,
--         },
--     },
-- })

-- Autocompletion
local cmp = require("cmp")
local mappin = cmp.mapping
cmp.setup({
    snippet = {
        expand = function(args)
            local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            insert({ body = args.body }) -- Insert at cursor
            cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            require("cmp.config").set_onetime({ sources = {} })
        end,
    },
    mapping = mappin.preset.insert({
        ["<C-j>"] = mappin.scroll_docs(-4),
        ["<C-k>"] = mappin.scroll_docs(4),
        ["<C-c>"] = mappin.abort(), -- close completion window
        ["<CR>"] = mappin.confirm({ select = true }),
    }),
    -- sources for autocompletion
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "async_path" },
        { name = "buffer" },
    }),

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "async_path" },
        { name = "cmdline" },
    }),
})

require("nvim-ts-autotag").setup({
    opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings
    -- doesn't work well in a specific filetype
    -- per_filetype = {
    --     ["html"] = {
    --         enable_close = false,
    --     },
    -- },
})

-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#native-commenting-in-neovim-010
-- using the builtin commenting functionality
require("ts_context_commentstring").setup({
    enable_autocmd = false,
})

local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
    return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
end
