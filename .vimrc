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
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'othree/html5.vim'
NeoBundle 'lunaru/vim-less'
NeoBundle 'tpope/vim-cucumber'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'kchmck/vim-coffee-script'
"""""""" plugins
" better status line
NeoBundle 'bling/vim-airline'
" smart syntax checker
NeoBundle 'scrooloose/syntastic'
" git integration
NeoBundle 'tpope/vim-fugitive'
" connect to Gist
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/gist-vim'
" Unite for search/completion
NeoBundle 'Shougo/vimproc', { 'build': {
      \   'windows': 'make -f make_mingw32.mak',
      \   'cygwin': 'make -f make_cygwin.mak',
      \   'mac': 'make -f make_mac.mak',
      \   'unix': 'make -f make_unix.mak',
      \ } }
" unite + plugins
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'thinca/vim-unite-history'
" color parenthesis
NeoBundle 'amdt/vim-niji'
" better start page
NeoBundle 'mhinz/vim-startify'
" a lot of iabbrev for common errors
NeoBundle 'chip/vim-fat-finger'
" emmet
NeoBundle 'mattn/emmet-vim'

if has("gui_running")
  " Smart completion
  " does not seem to work in console for mysterious reasons
  NeoBundle 'Valloric/YouCompleteMe', { 'build': {
        \   'mac': './install.sh',
        \   'unix': './install.sh',
        \ } }
  set guifont=Monaco:h15
endif

NeoBundle 'Shougo/neocomplcache.vim'
NeoBundle 'Shougo/neocomplcache-rsense.vim'
call neobundle#config('neocomplcache-rsense', {
      \ 'depends' : 'Shougo/neocomplcache.vim',
      \ 'autoload' : { 'filetypes' : 'ruby' }
      \ })
let g:neocomplcache#sources#rsense#home_directory = '/usr/local/bin'

NeoBundleCheck

" enable everything
filetype plugin indent on
syntax on
let mapleader=","

colorscheme toychest

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
let g:ctrlp_working_path_mode = 0
"""""""" Syntastic
" use google's gslint
let g:syntastic_javascript_checkers = ['gjslint', 'jslint']
" custom start header
let g:startify_custom_header = [
            \ '            __  _______ __  ____  __',
            \ '           / / / / ___// / / / / / /',
            \ '          / / / /\__ \/ /_/ / / / /',
            \ '         / /_/ /___/ / __  / /_/ /',
            \ '         \____//____/_/ /_/\____/',
            \ '',
            \ '',
            \ ]
" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" Neocomplete
let g:neocomplcache#enable_at_startup = 1
let g:neocomplcache#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

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
set nocindent

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
  autocmd! BufRead,BufNewFile Podfile setlocal filetype=ruby

  " auto removing of ending spaces
  autocmd FileType ruby,python,javascript,sh autocmd BufWritePre <buffer> :%s/\s\+$//e

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType python setlocal omnifunc=rubycomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
" %% = current directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :e %%<cr>
" keys for Gist
nnoremap <leader>l :Gist -l<cr>
" Unite
nnoremap <C-p> :Unite -start-insert file_rec/async<cr>
nnoremap <leader>/ :Unite grep:.<cr>
let g:unite_source_history_yank_enable = 1
nnoremap <leader>. :Unite history/yank<cr>
nnoremap <leader>b :Unite buffer<cr>
nnoremap <leader>m :Unite -start-insert outline<cr>
" emmet
let g:user_emmet_leader_key = ','
let g:user_emmet_expandabbr_key = '<C-@>'

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
     return pumvisible() ? "\<C-n>" : "\<C-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>
