local o = vim.opt
local k = vim.keymap.set

function safe_setup(module, params)
    success, val = pcall(require, module)
    if success then
        val.setup(params)
    end
end

o.background = "dark"
pcall(vim.cmd, "colorscheme kanagawa")

-- Options
o.splitbelow = true
o.wrap = false
o.exrc = true
o.number = true
o.relativenumber = true
o.expandtab = true
o.cursorline = true
o.splitright = true
o.splitbelow = true
o.termguicolors = true
o.shiftwidth = 4
o.timeoutlen = 750
o.cmdheight = 1
o.ignorecase = true
o.signcolumn = "yes"
o.completeopt = "menu,menuone,noinsert"
o.showbreak = "↪ "
o.list = true
o.autoindent = true
o.listchars = "lead:.,tab:▎·,trail:."

-- Thanks
-- https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
o.foldmethod = "expr"
o.foldenable = false
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.g.mapleader = " "

require("fruit.snippets")
require("fruit.terminal")
require("fruit.lsp")
require("fruit.git")
require("fruit.formatting")
require("fruit.linting")
require("fruit.pickin")
require("fruit.writing")
require("fruit.completions")
require("fruit.treesitter")

safe_setup("which-key")
safe_setup("colorizer")
require("mini.files").setup({
    windows = {
        max_number = 3,
        preview = true,
        width_preview = 50,
    },
    options = {
        permanent_delete = true,
        use_as_default_explorer = true,
    },
    mappings = {
        close = "<Esc>",
    },
})

local sections = {
    lualine_a = { "mode" },
    lualine_b = {
        {
            "filename",
            file_status = true,
            path = 1,
            symbols = {
                readonly = "[READONLY!]",
                newfile = "[New Buffer]",
            },
        },
    },
    lualine_c = { "location" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "branch", "diff", "diagnostics" },
}

require("fidget").setup()

require("lualine").setup({
    options = { theme = "dracula" },
    sections = sections,
    inactive_sections = sections,
})

k("n", "-", function()
    local files = require("mini.files")
    local exists = vim.fn.filereadable(vim.fn.expand(vim.api.nvim_buf_get_name(0)))
    if exists == 1 then
        files.open(vim.fn.expand(vim.api.nvim_buf_get_name(0), false))
    else
        files.open()
    end
end)
