return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local util = require("lspconfig.util")
		local keymap = vim.keymap

		-- Custom on_attach function
		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, silent = true }

			-- Buffer local mappings
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "Show LSP references", buffer = bufnr })
			keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = bufnr })
			keymap.set(
				"n",
				"gd",
				"<cmd>Telescope lsp_definitions<CR>",
				{ desc = "Show LSP definitions", buffer = bufnr }
			)
			keymap.set(
				"n",
				"gi",
				"<cmd>Telescope lsp_implementations<CR>",
				{ desc = "Show LSP implementations", buffer = bufnr }
			)
			keymap.set(
				"n",
				"gt",
				"<cmd>Telescope lsp_type_definitions<CR>",
				{ desc = "Show LSP type definitions", buffer = bufnr }
			)
			-- keymap.set(
			-- 	{ "n", "v" },
			-- 	"<leader>ca",
			-- 	vim.lsp.buf.code_action,
			-- 	{ desc = "See available code actions", buffer = bufnr }
			-- )
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename", buffer = bufnr })
			keymap.set(
				"n",
				"<leader>D",
				"<cmd>Telescope diagnostics bufnr=0<CR>",
				{ desc = "Show buffer diagnostics", buffer = bufnr }
			)
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics", buffer = bufnr })
			keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic", buffer = bufnr })
			keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic", buffer = bufnr })
			keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for cursor", buffer = bufnr })
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP", buffer = bufnr })
		end

		-- Configure diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Capabilities for autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- LSP server configurations
		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		lspconfig.ts_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.clangd.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.angularls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.cssls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig.html.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
		lspconfig.gopls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = { "gopls" }, -- Command to start the language server
			filetypes = { "go", "gomod", "gowork", "gotmpl" }, -- File types to activate gopls
			root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					completeUnimported = true,
					analyses = {
						unusedparams = true,
						nilness = true,
						unusedwrite = true,
						useany = true,
					},
					staticcheck = true,
				},
			},
		})
		lspconfig.pyright.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
