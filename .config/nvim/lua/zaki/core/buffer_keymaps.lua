local keymap = vim.keymap

-- Buffer navigation
keymap.set("n", "<space>]", ":BufferLineCycleNext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<space>[", ":BufferLineCyclePrev<CR>", { desc = "Go to previous buffer" })
keymap.set("n", "bx", ":bd<CR>", { desc = "Delete current buffer" })
keymap.set("n", "bc", ":bdelete<CR>", { desc = "Close current buffer" })
keymap.set("n", "ba", ":BufferLinePickClose<CR>", { desc = "Close all buffers except current" })
keymap.set("n", "bn", ":enew<CR>", { desc = "Create a new empty buffer" })

keymap.set("n", "[[", "^", { desc = "line beggining" })
keymap.set("n", "]]", "$", { desc = "line end" })

-- Switch to specific buffer by number (1 to 5 as example)
for i = 1, 5 do
	keymap.set("n", "<space>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go to buffer " .. i })
	keymap.set("n", "b" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>", { desc = "Go to buffer " .. i })
end

-- Move current buffer
keymap.set("n", "<space>bp", ":BufferLineMoveNext<CR>", { desc = "Move buffer to next position" })
keymap.set("n", "<space>bo", ":BufferLineMovePrev<CR>", { desc = "Move buffer to previous position" })
