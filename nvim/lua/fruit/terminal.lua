vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		local opt = vim.opt_local
		vim.cmd.startinsert()
		opt.relativenumber = false
		opt.number = false
		opt.signcolumn = "no"
	end,
})

-- https://github.com/mrshmllow/nvim-candy/blob/05bdda5412c3b4842a6cbe86a7f80f7fb9de79e8/candy/lua/marshmallow/autocmd.lua#L5-L10
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = id,
	callback = function()
		vim.cmd("wincmd =")
	end,
})

local k = vim.keymap.set
k("n", "<leader>t", vim.cmd.terminal, { desc = "Open Terminal" })
-- Add easy escape functionality like in INSERT mode
-- C-\ C-N is really annoying
k("t", "<ESC>", "<C-\\><C-N>")
