vim.api.nvim_create_autocmd("User", {
    pattern = "FugitiveEditor",
    callback = function()
        local opt = vim.opt_local
        vim.cmd.startinsert()
        -- opt.relativenumber = false
        -- opt.number = false
        opt.signcolumn = "no"
    end,
})
