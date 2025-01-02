local M = {}

-- General DAP key mappings
M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = {
			"<cmd> DapToggleBreakpoint <CR>",
			"Add breakpoint at line",
		},
		["<leader>dus"] = {
			"<cmd> lua require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes).open()<CR>",
			"Open debugging sidebar",
		},
	},
}

-- Go-specific DAP key mappings
M.dap_go = {
	plugin = true,
	n = {
		["<leader>dgt"] = {
			"<cmd> lua require('dap-go').debug_test()<CR>",
			"Debug Go test",
		},
		["<leader>dgl"] = {
			"<cmd> lua require('dap-go').debug_last()<CR>",
			"Debug last Go test",
		},
	},
}

-- Gopher.nvim Go-specific key mappings
M.gopher = {
	plugin = true,
	n = {
		["<leader>gsj"] = {
			"<cmd> GoTagAdd json <CR>",
			"Add JSON struct tags",
		},
		["<leader>gsy"] = {
			"<cmd> GoTagAdd yaml <CR>",
			"Add YAML struct tags",
		},
	},
}

-- Function to load key mappings from a module
function M.load_mappings(module)
	local mappings = M[module]
	if mappings then
		for mode, keymap in pairs(mappings) do
			if type(keymap) == "table" then
				for key, val in pairs(keymap) do
					vim.api.nvim_set_keymap(mode, key, val[1], { noremap = true, silent = true, desc = val[2] })
				end
			end
		end
	end
end

return M
