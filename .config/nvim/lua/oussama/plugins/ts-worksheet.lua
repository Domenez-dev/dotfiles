return {
	"typed-rocks/ts-worksheet-neovim",
	opts = {
		severity = vim.diagnostic.severity.WARN,
	},
	config = function(_, opts)
		require("tsw").setup(opts)
		vim.keymap.set("n", "<leader>tw", "<cmd>Tsw<cr>", { noremap = true, silent = true })
	end,
}
