"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cosmetic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" A colorscheme good for CLI and GUI
colorscheme evening

" exibir régua
set ruler

" highlight the current line
set cursorline

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

" Use Ctrl+L to clear the highlighting of :set hlsearch
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=1000
set tabpagemax=50



" TODO: I'd like to make it 80 characters long only if in a .md file...
"set textwidth=80

