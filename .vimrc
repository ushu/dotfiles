" vim:set ts=2 sts=2 sw=2 expandtab:

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LOAD PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load package manager
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

"""""""" keep package manager up-to-date
NeoBundleFetch 'Shougo/neobundle.vim'
"""""""" syntaxes
"NeoBundle 'pangloss/vim-javascript'
NeoBundle 'othree/html5.vim'
NeoBundle 'lunaru/vim-less'
NeoBundle 'tpope/vim-cucumber'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'kchmck/vim-coffee-script'
"""""""" plugins
" better ststus line
NeoBundle "bling/vim-airline"
" fast search through files
NeoBundle 'kien/ctrlp.vim'
" smart syntax checker
NeoBundle 'scrooloose/syntastic'
" Smart Tab completion
"NeoBundle "Shougo/neocomplcache.vim"
" git integration
NeoBundle "tpope/vim-fugitive"
"""""""" color
NeoBundle 'Lokaltog/vim-distinguished'

NeoBundleCheck

" enable everything
filetype plugin indent on
syntax on

colorscheme distinguished
set background=dark


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPTIONS FOR PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""" Ctrlp
" ignore node_modules, etc
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules$|vendor',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }
""" disable "root" detection (find .git => start at CWD)
let g:ctrlp_working_path_mode = ''
"""""""" Syntastic
" use google's gslint
let g:syntastic_javascript_checkers = ['gjslint', 'jslint']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TONS OF OPTIONS
" (these are mostly copied from Gary Bernhart's .vimrc)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cowboy mode on
set nocompatible
set nobackup
set noswapfile
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
set winwidth=79
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100

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

  autocmd!
  " Jump to last cursor position unless it's invalid or in an event handler
  " (in vim doc...)
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd! BufRead,BufNewFile *.sass setlocal filetype=sass
  autocmd! BufRead,BufNewFile *.json setlocal filetype=javascript
  autocmd! BufRead,BufNewFile Gemfile setlocal filetype=ruby
  autocmd! BufRead,BufNewFile Procfile setlocal filetype=ruby

  " auto removing of ending spaces
  autocmd FileType ruby,python,javascript,sh autocmd BufWritePre <buffer> :%s/\s\+$//e

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
nnoremap <leader>s <c-w>s
nnoremap <leader>v <c-w>v
nnoremap <leader>d <c-w>c
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
nnoremap <leader><leader> <c-^>
" %% = current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :e %%<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HANDLING THE EMPTY LINES END OEL SPACES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color in rend EOL spaces and empty lines
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TRYING TO LEARN fugitive ?
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gs :Gstatus<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VERY fast Tab completion from Gary Bernhart's vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-n>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>
