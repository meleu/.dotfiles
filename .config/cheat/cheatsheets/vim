---
tags: [ vim ]
---
# cool combos
xp      transpose characters
yis     copy current sentence
yip     copy current paragraph
ggyG    copy the whole file
gd      Go to the Declaration of the variable under the cursor

# fix file indentation from CLI
# https://stackoverflow.com/q/65318076/6354514
vim -c 'norm gg=G' -c 'wq' file.ext

# vim's factory settings
vim -u NONE -N

# things I want to memorize now
###############################################################################

# search in the line
# capital f and t searches backwards
f<char>   puts the cursor in the next occurrence of `<char>`
t<char>   puts the cursor right before the next occurrence of `<char>`
;         goes to the next occurrence
,         goes to the previous occurrence


# text objects (see also :help Q_to)
# each one must be preceded by 'i' (inner) or 'a' (include boundaries)
s     sentence
p     paragraph
t     xml <tag></tag>
",',` quoted strings
[,]   blocks with [brackets]
(,)   blocks with (parenthesis)
{,}   blocks with {curly brackets}
<,>   blocks with <parenthesis>
i     indentation (plugin: vim-textobj-indent)
l     line without leading white spaces (plugin: vim-textobj-line)


# toggle boolean configs: append a '!'
# example for relativenumber
:set relativenumber!

# see a value of a config: append a '?'
:set wrapmargin?


# windows
###############################################################################
:new      creates a new horizontal split
:vnew     creates a new vertical split
:split    open a file in a horizontal split
:vsplit   open a file in a vertical split

^w [hjkl]   move cursor between windows
^w [HJKL]   move the current window
^w [+-]     resize vertically
^w [<>]     resize horizontally
^w =        rebalance windows sizes
^w T        break current window in a new tab


# tabs
:tabnew                   creates an empty tab
:tabedit <filename.ext>   opens a file in a new tab

gt,gT           move between tabs forward,backward

###############################################################################

# search

*     search the word in the cursor
\#    search the word in the cursor backwards
gd    Go to the Declaration of the variable under the cursor


# movement

^f,^b     scroll one screen forward(down)/backward(up)
(, )      start/end of the current sentence
{, }      top/bottom of the current paragraph
[[, ]]    previous/next section (useful in markdown)
[{, ]}    open/closing braces of the current code block
H, M, L   (High, Middle, Low) top, middle, bottom of the viewport
zz        scroll the window putting the contents in the cursor in the center
zt, zb    same as above, but putting in the Top/Bottom
f{char}   find a char forward in the line ('F' goes backward)
t{char}   find a char forward in line and move right before it ('T' backward)
;         repeat last f, F, t or T command
,         same as above, but in opposite direction
m{char}   mark the current line as {char}
\'{char}   go to the line marked as {char}
m{CHAR}   mark the current line in the specific file as {CHAR}


# text objects

tip 1 : prefer using text-objects rather than motions in
        order to increase repeatability (see ':h text-objects').
tip 2 : practice using 'v' (visual).
note  : the combinations below are intended to be used AFTER an
        action key (e.g.: 'diw' delete inner word).

iw, aw    "inner word", "a word" ('a' includes space)
ip, ap    "inner paragraph"...
is, as    "inner sentence "...
i), a)    "inner parenthesis", 'a' includes surrounding ')' (same for { and [)
i", a"    "inner quotes"... (same for single quote)
it, at    "inner tag" (HTML tag)

# File management

:e              reload file
:x              write file and exit


# Insertion
#   To exit from insert mode use Esc or ^C
#   Enter insertion mode and:

:r {file}       insert from file



# ---[ from the original cheatsheet ]---



# Multiple windows
:e filename      - edit another file
:split filename  - split window and load another file
^w up arrow  - move cursor up a window
^w ^w    - move cursor to another window (cycle)
^w_          - maximize current window
^w=          - make all equal size
10 ^w+       - increase window size by 10 lines
:vsplit file     - vertical split
:sview file      - same as split, but readonly
:hide            - close current window
:only            - keep only this window open
:ls              - show current buffers
:.! <command>    - shell out

# Buffers
# move to N, next, previous, first last buffers
:bn              - goes to next buffer
:bp              - goes to prev buffer
:bf              - goes to first buffer
:bl              - goes to last buffer
:b 2             - open buffer #2 in this window
:new             - open a new buffer
:vnew            - open a new vertical buffer
:bd 2            - deletes buffer 2
:wall            - writes al buffers
:ball            - open a window for all buffers
:bunload         - removes buffer from window
:taball          - open a tab for all buffers

