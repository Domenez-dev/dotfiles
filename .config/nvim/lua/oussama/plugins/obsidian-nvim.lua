return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	event = {
		"BufReadPre /home/oussama/projects/Notes/*.md",
		"BufNewFile /home/oussama/projects/Notes/*.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "Notes",
				path = "/home/oussama/projects/Notes",
			},
		},
		-- Disable UI if not needed
		ui = {
			enable = false,
		},

		-- Use the title exactly as the note ID (file name).
		note_id_func = function(title)
			-- Just return the title as it is
			return title
		end,

		-- Use the title exactly as the file name.
		note_path_func = function(spec)
			-- Simply return the directory and the title (no modification).
			return tostring(spec.dir) .. "/" .. spec.title .. ".md"
		end,
	},
}
