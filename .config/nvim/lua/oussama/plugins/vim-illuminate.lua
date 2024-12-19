return {
	"RRethy/vim-illuminate",
	event = "CursorHold",
	config = function()
		require("illuminate").configure({
			providers = {
				"lsp",
				"treesitter",
				"regex",
			},
			delay = 100,
			filetypes_blacklist = {
				"TelescopePrompt",
				"vimwiki",
				"markdown",
				"text",
			},
		})
	end,
}
