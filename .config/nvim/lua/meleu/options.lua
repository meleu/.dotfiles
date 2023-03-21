local options = {
  -- visual hints
  number = true,
  relativenumber = true,
  ruler = true,
  showcmd = true,         -- show command in status bar
  colorcolumn = "80,120", -- highlight some meaningful columns
  cursorline = true,      -- highlight the line where the cursor is
  scrolloff = 8,          -- when scrolling up/down, show at least 3 lines
  showmatch = true,       -- highlight matching brackets while typing
  linebreak = true,       -- avoid wrapping a line in the middle of a word
  showtabline = 2,        -- always show tabs on top of the screen

  -- indentation
  autoindent = true,
  smartindent = true,

  -- tab = 2 spaces
  tabstop = 2,            -- spaces to show a real <tab>
  expandtab = true,       -- output spaces when pressing <tab>
  softtabstop = 2,        -- spaces to output when pressing <tab>
  shiftwidth = 2,         -- spaces for each level of indentation
  smarttab = true,        -- smartly dealing with tabs :)

  -- searching
  hlsearch = true,
  wrapscan = true,        -- loop through the file when doing a search
  incsearch = true,       -- jump to the matching text while typing
  ignorecase = true,      -- ignore case-sensitiviness...
  smartcase = true,       -- ..unless there's a capital letter.

  -- edit
  pastetoggle = "<F2>",   -- use <F2> to toggle paste mode

  -- handling windows/tabs/buffers
  splitbelow = true,      -- horizontal splits go below
  splitright = true,      -- vertical splits go right

  -- handling files
  backup = false,         -- do not save backups (file.txt~)
  autoread = true,        -- read from disk
  history = 1000,         -- ???
  tabpagemax = 50,        -- ???
  undofile = true,        -- keeps undo history between sessions
  undodir = vim.env.HOME .. "/.local/state/nvim/undo",

}

for key, value in pairs(options) do
  vim.opt[key] = value
end
