"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install plugins with vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
"Plug 'ctrlpvim/ctrlp.vim'
Plug 'vimwiki/vimwiki'

" needed to allow repetition with dot for surround, commentary, etc.
Plug 'tpope/vim-repeat'

" {verb}s{text object} - eg: ds' = Delete Surrounding 'Quotes'
Plug 'tpope/vim-surround'

" gc{text object} - Go Comment
Plug 'tpope/vim-commentary'

" cx - Copy & Exchange
" cx{text object} and then repeat for another text object
" cxx - for current line
" X - for visual mode
" cxc - to cancel the pending exchange
Plug 'tommcdo/vim-exchange'

" gr{text object} - Go Replace
Plug 'inkarkat/vim-ReplaceWithRegister'

" gs{text object} - Go Sort
Plug 'christoomey/vim-sort-motion'

" necessary for plugins that create custom text objects
Plug 'kana/vim-textobj-user'

" creates the 'i' indent text object
" preceded with 'i': referst to an indented paragraph
" preceded with 'a': refers to the whole indented block
Plug 'kana/vim-textobj-indent'

" creates the 'l' line text object
" the only difference from the whole line is that this text object
" ignores the preceding white spaces
Plug 'kana/vim-textobj-line'

" format my shellscript code (required 'shfmt')
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }

" trying to get shellcheck analysis while coding
Plug 'vim-syntastic/syntastic'

" useful for bash scripting
" NOTE: interesting ideas, but I didn't actually like it.
"Plug 'WolfgangMehner/bash-support'

call plug#end()

" plugins configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vimwiki
let g:vimwiki_list = [{'path': '~/src/github/meleudotdev', 'syntax': 'markdown', 'ext': '.md'}]

" vim-shfmt
let g:shfmt_fmt_on_save = 1
" 2 spaces, binary next line, space redirects, case indent
let g:shfmt_extra_args = '-i 2 -bn -sr -ci'

" Syntastic (for shellcheck)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neovim specific configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  " make the nvim talk with the system's clipboard
  set clipboard+=unnamedplus

  " https://neovim.io/doc/user/lua.html#lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank {timeout=500}
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" hotkeys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ctrl-s to save (normal/insert mode)
map <C-s> <esc>:w<cr>
imap <C-s> <esc>:w<cr>

" ctrl-o to save (normal/insert mode)
map <C-o> <esc>:tabe .<cr>
imap <C-o> <esc>:tabe .<cr>

" ctrl-\ to toggle comments
" depends on plugin tpope/vim-commentary
vmap <C-\> gc
nmap <C-\> gcc
imap <C-\> gcc

" ctrl-space for autocompletion menu
imap <C-Space> <C-n>

" Use Ctrl+n to clear the highlighting of :set hlsearch
"map <C-n> <esc>:nohlsearch<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" my 'leader-keys'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use space as the leader key
let mapleader = "\<Space>"

" reload my vimrc
nmap <leader>r :source $MYVIMRC<cr>

" quickly open my .vimrc
" nmap <leader>vi :tabedit $MYVIMRC<cr>
nmap <leader>vi :tabedit ~/.vimrc<cr>

" quickly open my .tmux.conf
nmap <leader>tm :tabedit ~/.tmux.conf<cr>

" copy the whole file
map <leader>cf ggVGy

" go to the next/previous error (useful for syntastic/shellcheck)
map <leader>ne :lnext<cr>
map <leader>pe :lprevious<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cosmetic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" A colorscheme good for CLI and GUI
" colorscheme evening

" exibir régua
set ruler

" highlight the current line
" set cursorline

" always show status line
set laststatus=2

" Syntax highlighting
syntax on

" Show the number of lines
set number

" Show the number of lines relative to the current one
" NOTE: not useful when pair programming
"set relativenumber

" Show commands in status bar
set showcmd

" When a bracket is typed, the cursor highlight the matching opening bracket.
set showmatch

" When scrolling up or down, show at least 3 lines above/below
set scrolloff=3

" From nerd-fonts:
" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
set guifont=Monospace\ 16
" nice way to set the default font for GUI:
" - `:set guifont=*` to open the dialog box to chose a font
" - choose the font
" - use `:set guifont?` to see the command to be used in the `.vimrc`


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Coding style (no tabs, 2 spaces indentation)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto indentation.
set autoindent smartindent

" Number of spaces to show when displaying a tab
set tabstop=2

" Number of spaces for each step of the (auto)indent
set shiftwidth=2

" When pressing the tab, put spaces instead.
" To insert an actual tab, use ctrl-v <tab>.
set expandtab

" A tab at the beginning of a line, put the amount of spaces defined in 'shiftwidth'.
" In other places the 'tabstop' is used.
" A backspace deletes a 'shiftwidth'.
set smarttab


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Searching...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight the text being searched
set hlsearch

" When searching with '/', jump to the matching text while typing.
set incsearch

" When searching with '/', ignore case-sensitiveness.
set ignorecase

" Ignore case-sensitiveness only when using lower case.
set smartcase



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoread        " read from disk
"set nobackup       " do not save the backup/swap files
set history=1000
set tabpagemax=50

" when in a big soft-wrapped line, make j and k feel more 'natural'
nmap k gk
nmap j gj
"nmap k gkzz " didn't the experience while browsing the :help
"nmap j gjzz

" try to keep the cursor in the middle of the screen (horizontally)
nmap G Gzz

" be aware of my typos
command! Q q
command! W w
command! WQ wq

" bind q to close the buffer for help files
autocmd Filetype help nnoremap <buffer> q :q<cr>


" TODO: I'd like to make it 80 characters long only if in a .md file...
"set textwidth=80

