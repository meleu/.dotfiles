set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc

" make the nvim talk with the system's clipboard
set clipboard+=unnamedplus

" https://neovim.io/doc/user/lua.html#lua-highlight
au TextYankPost * silent! lua vim.highlight.on_yank()

