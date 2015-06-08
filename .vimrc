" vim:set ts=2 sts=2 sw=2 expandtab:

"""
""" BASE SETTINGS 
"""

set encoding=utf-8
set nocompatible

let mapleader=","

" Allow multiple edition on a file
set nobackup
set noswapfile
set hidden

" Enable default highlighting
syntax on
filetype plugin indent on

" enable auto indent
set autoindent
set nocindent
" default indent settings: 2 space-based shifts
set tw=79 ts=2 sw=2 expandtab


"""
""" FILETYPE-SPECIFIC SETTINGS
"""

" Load the right plugin for the right file
augroup SyntaxEx

  " HTML & Co
  autocmd! BufRead,BufNewFile *.html setlocal filetype=html
  " CSS & Co
  autocmd! BufRead,BufNewFile *.sass setlocal filetype=sass
  autocmd! BufRead,BufNewFile *.scss setlocal filetype=scss
  autocmd! BufRead,BufNewFile *.coffee setlocal filetype=coffee
  autocmd! BufRead,BufNewFile *.less setlocal filetype=less
  autocmd! BufRead,BufNewFile *.styl setlocal filetype=stylus
  " JS
  autocmd! BufRead,BufNewFile *.json setlocal filetype=json
  " Ruby (.rb detected by default)
  autocmd! BufRead,BufNewFile *.erb setlocal filetype=eruby
  autocmd! BufRead,BufNewFile *.feature setlocal filetype=cucumber
  autocmd! BufRead,BufNewFile Gemfile,Procfile,Podfile,VagrantFile,Cheffile setlocal filetype=ruby
  " Python (.py detected by default)
  autocmd! BufRead,BufNewFile .pryrc setlocal filetype=ruby
  " Go
  autocmd! BufRead,BufNewFile *.go setlocal filetype=go
  " Markdown (replace markdown by github markdown everywhere)
  autocmd! BufNewFile,BufRead *.md,*.markdown setlocal filetype=mkd

augroup END

" Indent
augroup IndentEx

  autocmd! BufRead,BufNewFile *.go setlocal tw=4 ts=4 sw=4 noexpandtab

augroup END

"""
""" Updated defaults
"""

" search options: incremental + highlight + case insensitive
set incsearch
set hlsearch
set ignorecase smartcase

" make searches case-sensitive only if they contain upper-case characters
set switchbuf=useopen,usetab
set winwidth=79

" Avoid clobbering the scrollback buffere " http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" improve command line insert mode
set backspace=indent,eol,start
set showcmd
set wildmode=longest,list
set wildmenu

" Fix slow inserts
set timeout timeoutlen=1000 ttimeoutlen=100

" make shell work with Rails
set shell=bash

"""
""" NAVIGATION
"""

" Disable arrow navigation
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" split commands
nnoremap <leader>s <c-w>s
nnoremap <leader>v <c-w>v
nnoremap <leader>d <c-w>c

" c-C == ESC
imap <c-c> <esc>

" navigation
nnoremap <leader><leader> <c-^>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :e %%<cr>

"""
""" (GARY BENRHART's) MACROS
"""

" Jump to last cursor position when opening file (from vim doc)
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" rename file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" color in rend EOL spaces and empty lines
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" auto removing of ending spaces
augroup RemoveEOL
  autocmd FileType ruby,python,javascript,sh,css autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

"""
""" PLUGINS
"""

" see https://github.com/junegunn/vim-plug for options !

call plug#begin('~/.vim/plugged')

" Look and Feel
Plug 'junegunn/seoul256.vim'
Plug 'bling/vim-airline'

" Indent for files
Plug 'editorconfig/editorconfig-vim'

" Check for errors on save
Plug 'scrooloose/syntastic', { 'for' : [ 'ruby' ] }

" HTML support
Plug 'othree/html5.vim', { 'for': [ 'html' ] }
Plug 'tpope/vim-haml', { 'for': [ 'haml' ] }
Plug 'mattn/emmet-vim', { 'on': [] }

" CSS support
Plug 'hail2u/vim-css3-syntax', { 'for': [ 'css', 'scss' ] }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'wavded/vim-stylus', { 'for': 'stylus' }

" Ruby support
Plug 'vim-ruby/vim-ruby', { 'for': [ 'ruby', 'eruby' ] }

" Go support
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'nsf/gocode', { 'for': 'go', 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" Git tools
Plug 'tpope/vim-fugitive'
Plug 'junegunn/vim-github-dashboard', { 'on': [ 'GHDashboard', 'GHActivity' ] }

" Fuzzy finder for files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Smart completion
" All these plugins will be loaded *on demand*
Plug 'ervandew/supertab', { 'on': [] }
Plug 'SirVer/ultisnips', { 'on': [] }
Plug 'honza/vim-snippets', { 'on': [] }
Plug 'Valloric/YouCompleteMe', { 'on': [], 'do': './install.sh --clang-completer --gocode-completer' }

" Better grep
Plug 'rking/ag.vim'

call plug#end()

" Configure color scheme
set background=dark
let g:seoul256_background = 233
color seoul256

" Setup status bar to work with OSX Terminal.app
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep=''
let g:airline_right_sep=''

" Custom mapping the file finders
nnoremap <leader>i :FZF<CR>
nnoremap <leader>/ :Ag<space>-i<space>

" Custom mappings for Fugitive
" <leader>-SPACE to enter any git command
nnoremap g<Space> :Git<Space>
" g-X for git command (X = first letter of the command)
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gb :Gblame<CR>
nnoremap gd :Gdiff<CR>
nnoremap gD <c-w>h<c-w>c
nnoremap gl :Glog<CR>
vnoremap <leader>p :diffput<CR>:diffupdate<CR>
vnoremap <leader>o :diffget<CR>:diffupdate<CR>

" Configuration sor Syntactic
let g:syntastic_javascript_checkers = [ 'gjslint', 'jslint' ]

" Avoid conflict between fugitive and editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Custom keys for the completion engin
" map all the plugins to TAB for expand + C-n/C-p for completions
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" load plugins on insert only
augroup load_us_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('supertab', 'ultisnips', 'vim-snippets', 'YouCompleteMe')
  autocmd InsertEnter * call youcompleteme#Enable() | autocmd! load_us_ycm
augroup END

" Emmet
let g:user_emmet_expandabbr_key='<Tab>'

augroup load_emmet
  autocmd InsertEnter *.html,*.css,*.scss call plug#load('emmet-vim')
  autocmd InsertEnter *.html,*.css,*.scss EmmetInstall
  autocmd InsertEnter imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
augroup END


