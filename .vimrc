set ttyfast " Improves smoothness of redrawing

" Don't redraw while executing macros (good performance config)
set lazyredraw

set noerrorbells
set novisualbell
set t_vb=

set t_Co=256 " using 256 colors

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" With a map leader it's possible to do extra key combinations
let mapleader = "\<Space>"

" Enable clipboard if possible
if has('clipboard')
    if has('unnamedplus') " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

set autoindent " Auto indent
set smartindent " Smart indent

filetype on

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set smarttab

set expandtab " Use spaces instead of tabs

set wrap " Wrap lines

" set iskeyword+=-
set whichwrap+=<,>,h,l,[,]

" Enable syntax highlighting
syntax enable

" Always show current position
set ruler

" Show line number by default
set number relativenumber

" Turn spell check off
set nospell

" Height of the command bar
set cmdheight=1
" Turn on the Wild menu
set wildmenu
set wildmode=list:longest,full
" Ignore compiled files
set wildignore=*.so,*.swp,*.pyc,*.pyo,*.exe,*.7z
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*,*\desktop.ini
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" }}} Appearence - Scrollbar, Highlight, Linenumber "

" Edit - Navigation, History, Search {{{ "

" Map jk to enter normal mode
imap jk <Esc>

" Turn persistent undo on, means that you can undo even when you close a buffer/VIM
set undofile
set undolevels=1000

" For regular expressions turn magic on
set magic

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't wrap around when jumping between search result
" set nowrapscan

" Disable highlight when <Backspace> is pressed
nnoremap <silent> <BS> :nohlsearch<CR>

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

colorscheme default

" Have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" ripgrep->fzf->vim [QUERY]
rfv() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            '$EDITOR' {1} +{2}     # No selection. Open the current line in Vim.
          else
            '$EDITOR' +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'batcat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)

" same as above but perform fuzzy finding
rf () (
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            '$EDITOR' {1} +{2}     # No selection. Open the current line in Vim.
          else
            '$EDITOR' +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
    rg --column --color=always --smart-case "" | fzf --ansi --multi -n 4.. \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'batcat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)
