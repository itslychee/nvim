require("ts_context_commentstring").setup({
	enable_autocmd = false,
})
success, val = pcall(require, "nvim-treesitter.configs")
if success then
	val.setup({
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		-- indent = { enable = true },
	})
end
