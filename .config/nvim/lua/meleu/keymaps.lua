-- ???
local opts = {
  noremap = true,
  silent = true,
}
local term_opts = { silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------------------------------------------------------------
-- modes
-------------------------------------------------------------------------------
-- n: normal
-- i: insert
-- v: visual
-- x: visual-block
-- t: terminal
-- c: command

-- normal
-------------------------------------------------------------------------------
-- better movements
keymap("n", "k", "gkzz", opts)
keymap("n", "j", "gjzz", opts)
keymap("n", "G", "Gzz", opts)
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)

-- better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- open the file explorer
keymap("n", "<leader>e", ":Lexplore 30<cr>", opts)

-- resize with arrows
keymap("n", "<C-Up>",    ":resize +2<cr>", opts)
keymap("n", "<C-Down>",  ":resize -2<cr>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<cr>", opts)
keymap("n", "<C-Left>",  ":vertical resize -2<cr>", opts)

-- navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

-- leader key shortcuts ---
-- toggle hlsearch
keymap("n", "<leader>hs", ":set hlsearch!<cr>", opts)

-- toggle relativenumber
keymap("n", "<leader>rn", ":set relativenumber!<cr>", opts)

-- shortcut to the quickref
keymap("n", "<leader>qr", ":help quickref<cr>", opts)

keymap("n", "<leader>cf", ":%y<cr>", opts)

-- visual
-------------------------------------------------------------------------------
-- stay highlighted after indent
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move text up/down
-- TODO: this is not working as expected
-- see ThePrimeagen video, he also uses this
keymap("v", "<A-j>", ":move .+1<cr>==", opts)
keymap("v", "<A-k>", ":move .-2<cr>==", opts)

-- delete selected text sending it to the "blackhole register", then paste
-- the contents of the unnamed register.
keymap("v", "p", '"_dP', opts)


-- visual block
-------------------------------------------------------------------------------
-- move text up/down
--keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
--keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
--keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
--keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- terminal
-------------------------------------------------------------------------------
-- Better terminal navigation
--keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
--keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
--keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
--keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
