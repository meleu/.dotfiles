"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neovim specific configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  " make the nvim talk with the system's clipboard
  set clipboard+=unnamedplus

  " https://neovim.io/doc/user/lua.html#lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank {timeout=500}
endif

" Set <Space> as the leaderkey
let mapleader = "\<Space>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use :help option-list for aquick reference to all options.
" Use :help 'option (including the ' character) to learn more about each one.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" visual hints
set number
set relativenumber
set ruler
set showcmd             " show command in status bar
set colorcolumn=80,120  " highlight some meaningful columns
set cursorline          " highlight the cursor line
set scrolloff=8         " when scrolling up/down, show at least N lines
set showmatch           " highlight matching brackets while typing
set linebreak           " avoid wrapping a line in the middle of a word
set showtabline=2       " always show tabs on top of the screen
set laststatus=2        " always show status line

" tab & indentation
set autoindent
set smartindent
set smarttab
set expandtab           " output spaces when pressing <tab>
set softtabstop=2       " N spaces to output when pressing <tab>
set tabstop=2           " N spaces to show a real <tab>
set shiftwidth=2        " N spaces for each level of indentation

" searching
set hlsearch
set wrapscan            " loop through the file when doing a search
set incsearch           " jump to the matching text while typing
set ignorecase          " ignore case-sensitiveness...
set smartcase           " ... unless there's a capital letter

" edit
set pastetoggle=<f2>    " use <F2> to toggle paste mode

" handling windows/tabs/buffers
set splitbelow          " horizontal splits go below
set splitright          " vertical splits go right

" handling files
set nobackup            " don't save backups (e.g.: file.txt~)
set autoread            " read from disk
set history=1000        " ???
set tabpagemax=50       " ???
set undofile            " keeps undo history between sessions
set undodir=~/.vim/undodir  " directory to save undo history

syntax on

" nice way to set the default font for GUI:
" - `:set guifont=*` to open the dialog box to chose a font
" - choose the font
" - use `:set guifont?` to see the command to be used in the `.vimrc`
set guifont=Monospace\ 16

" removing bad LunarVim weird defaults
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" prevent l and h to go to the next/previous line
set whichwrap=b,s

set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key [re]maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" modes
" - n: normal
" - i: insert
" - v: visual
" - x: visual-block
" - t: terminal
" - c: command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" keeping cursor in the middle line
" nnoremap k gkzz
" nnoremap j gjzz
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
" nnoremap p pzz
" nnoremap P Pzz
nnoremap } }zz
nnoremap { {zz

" better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" reload my vimrc
nmap <leader>rv :source $MYVIMRC<cr>

" open the file explorer
nmap <leader>e :Lexplore 30<cr>

" turn off hlsearch
nmap <leader>h :nohlsearch<cr>

" toggle relativenumber
nmap <leader>rn :set relativenumber!<cr>

" shortcut to the quickref
nmap <leader>qr :help quickref<cr>

" quickly copy the whole file
nmap <leader>cf :%yank<cr>

" quickly open my .vimrc
" NOTE: for neovim the $MYVIMRC is ~/.config/nvim/init.vim
" nmap <leader>vi :tabedit $MYVIMRC<cr>
nmap <leader>vi :tabedit ~/.vimrc<cr>

" quickly open my .tmux.conf
nmap <leader>tm :tabedit ~/.tmux.conf<cr>

" visual
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" stay highlighted after indent
"vnoremap < <gv
"vnoremap > >gv

" replace selection but don't overwrite the register
vnoremap p "_dP

" apply the dot command on each line of the selection
vmap . :normal .<cr>

" misc...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" be aware of my typos
command! Q q
command! W w
command! WQ wq

" bind q to close the buffer for help files
autocmd Filetype help nnoremap <buffer> q :q<cr>


" templates
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:autocmd BufNewFile *.sh 0r ~/.vim/templates/bash.tpl
 
