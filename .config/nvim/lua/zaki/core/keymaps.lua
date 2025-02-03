vim.g.mapleader = " "

local keymap = vim.keymap

-- use jk to exit insert mode
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", ";;", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", ";", ":", { desc = "use ; as :" })
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit file" })
keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "Force quit file" })

-- Move across wrapped lines
keymap.set("n", "j", "v:count > 0 ? 'j' : 'gj'", { noremap = true, expr = true, silent = true })
keymap.set("n", "k", "v:count > 0 ? 'k' : 'gk'", { noremap = true, expr = true, silent = true })
keymap.set("n", "<A-a>", "gg^vGg_", { desc = "Select all text" })

keymap.set({ "n", "o", "x" }, "<s-h>", "^", { desc = "Jump to beginning of line" })
keymap.set({ "n", "o", "x" }, "<s-l>", "g_", { desc = "Jump to end of line" })
-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete without copying into register
keymap.set("n", "x", '"_d', { noremap = true, silent = true })
keymap.set("n", "c", '"_c', { noremap = true, silent = true })
keymap.set("v", "x", '"_x', { noremap = true, silent = true })
keymap.set("v", "c", '"_c', { noremap = true, silent = true })
keymap.set("n", "xx", '"_dd', { noremap = true, silent = true })
keymap.set("n", "<leader>/", ":noh<CR>", { noremap = true, silent = true })

-- keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("x", "<leader>p", '"_dP')

keymap.set("n", "<leader>d", '"_d')
keymap.set("v", "<leader>d", '"_d')

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
