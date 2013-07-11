" vim:set ts=2 sts=2 sw=2 expandtab:

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PACKAGES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" upadate
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))
 
NeoBundleFetch 'Shougo/neobundle.vim'
" syntaxes
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'othree/html5.vim' 
NeoBundle 'lunaru/vim-less' 
NeoBundle 'tpope/vim-cucumber' 
NeoBundle 'cakebaker/scss-syntax.vim'
" plugins
"" add C-p to loop through previous yanks
NeoBundle 'YankRing.vim'
"" fast search through files
NeoBundle 'kien/ctrlp.vim'
"" (we change the mapping to `` to avoid collision with the yankring)
:noremap `` :CtrlP<cr>
:noremap <leader>` :CtrlPClearCache<cr> :CtrlP<cr>
"" ignore
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules$',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }
"" smart syntax checker
NeoBundle 'scrooloose/syntastic'
let g:syntastic_javascript_checkers = ['gjslint', 'jslint']
NeoBundleCheck

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TONS OF OPTIONS
" (these are mostly copied from Gary Bernhart's .vimrc)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
" allow unsaved buffers
set hidden
" remember more commands and search history
set history=10000
set laststatus=2
" show mathing paren
set showmatch
" search options
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Store temporary files in a central spot
set nobackup
set noswapfile
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" color
colorscheme koehler

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EDIT OPTIONS 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set ignorecase smartcase

set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 
  autocmd! BufRead,BufNewFile *.json setfiletype javascript
  autocmd! BufRead,BufNewFile Gemfile setfiletype ruby
  autocmd! BufRead,BufNewFile Procfile setfiletype ruby

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","

map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" more split joy
nnoremap <leader>j <c-w>s <c-w>j
nnoremap <leader>k <c-w>s
nnoremap <leader>h <c-w>v
nnoremap <leader>l <c-w>v <c-w>l
nnoremap <leader>d <c-w>c
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>
" %% = current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :e %%<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

