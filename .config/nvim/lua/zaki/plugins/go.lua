return {
	-- nvim-dap for debugging
	{
		"mfussenegger/nvim-dap",
		init = function()
			require("zaki.core.go_dap").load_mappings("dap") -- Load mappings from keymapping.lua
		end,
	},
	-- nvim-dap-go for Go debugging
	{
		"dreamsofcode-io/nvim-dap-go",
		ft = "go",
		dependencies = "mfussenegger/nvim-dap",
		config = function(_, opts)
			require("dap-go").setup(opts)
			require("zaki.core.go_dap").load_mappings("dap_go") -- Load Go-specific dap mappings
		end,
	},
	-- null-ls for formatting Go code
	{
		"jose-elias-alvarez/null-ls.nvim",
		ft = "go",
		opts = function()
			return require("zaki.configs.null-ls.go") -- Go-specific null-ls configuration
		end,
	},
	-- gopher.nvim for Go struct tags and other features
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		config = function(_, opts)
			require("gopher").setup(opts)
			require("zaki.core.go_dap").load_mappings("gopher") -- Load Go-specific gopher mappings
		end,
		build = function()
			vim.cmd([[silent! GoInstallDeps]]) -- Automatically install Go dependencies
		end,
	},
}
