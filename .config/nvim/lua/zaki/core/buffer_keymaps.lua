local keymap = vim.keymap

-- Buffer navigation
keymap.set("n", "<space>]", ":BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<space>[", ":BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "<space>bx", ":bd<CR>", { desc = "Delete current buffer" })
keymap.set("n", "<space>bc", ":bdelete<CR>", { desc = "Close current buffer" })
keymap.set("n", "<space>ba", ":BufferLinePickClose<CR>", { desc = "Close all buffers except current" })
keymap.set("n", "<space>bn", ":enew<CR>", { desc = "Create a new empty buffer" })

-- Switch to specific buffer by number (1 to 5 as example)
for i = 1, 10 do
	keymap.set("n", "<space>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go to buffer " .. i })
end

-- Move current buffer
keymap.set("n", "<space>b]", ":BufferLineMoveNext<CR>", { desc = "Move buffer to next position" })
keymap.set("n", "<space>b[", ":BufferLineMovePrev<CR>", { desc = "Move buffer to previous position" })
