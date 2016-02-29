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
" default indent settings (overloaded by editorconfig most of the time)
set tabstop=2 softtabstop=0 expandtab shiftwidth=4 smarttab
" and a width of 80 chars
set textwidth=79

"""
""" FILETYPE-SPECIFIC SETTINGS
"""

" Load the right plugin for the right file
augroup SyntaxEx

  " HTML & Co
  autocmd! BufNewFile,BufRead *.html setlocal filetype=html
  autocmd! BufNewFile,BufRead *.jade setlocal filetype=jade
  " CSS & Co
  autocmd! BufNewFile,BufRead *.sass setlocal filetype=sass
  autocmd! BufNewFile,BufRead *.scss setlocal filetype=scss
  autocmd! BufNewFile,BufRead *.coffee setlocal filetype=coffee
  autocmd! BufNewFile,BufRead *.less setlocal filetype=less
  autocmd! BufNewFile,BufRead *.styl setlocal filetype=stylus
  " JS
  autocmd! BufNewFile,BufRead *.json setlocal filetype=json
  autocmd! BufNewFile,BufRead *.es6 setlocal filetype=javascript
  autocmd! BufNewFile,BufRead *.ts setlocal filetype=typescript
  autocmd! BufNewFile,BufRead *.jsx setlocal filetype=jsx
  " Ruby (.rb detected by default)
  autocmd! BufNewFile,BufRead *.erb setlocal filetype=eruby
  autocmd! BufNewFile,BufRead *.feature setlocal filetype=cucumber
  autocmd! BufNewFile,BufRead Gemfile,Procfile,Podfile,VagrantFile,Cheffile setlocal filetype=ruby
  " Python (.py detected by default)
  autocmd! BufNewFile,BufRead .pryrc setlocal filetype=ruby
  " Go
  autocmd! BufNewFile,BufRead *.go setlocal filetype=go
  " Markdown (replace markdown by github markdown everywhere)
  autocmd! BufNewFile,BufRead *.md,*.markdown setlocal filetype=mkd

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
set wildmode=list:full
set wildmenu

" Fix slow inserts
set timeout timeoutlen=1000 ttimeoutlen=100

" make shell work with Rails
set shell=bash

"""
""" NAVIGATION
"""

" Close buffer
nnoremap <leader>q :q<CR>
nnoremap <leader><S-q> :q!<CR>

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
Plug 'scrooloose/syntastic'

" HTML support
Plug 'othree/html5.vim', { 'for': [ 'html' ] }
Plug 'tpope/vim-haml', { 'for': [ 'haml' ] }
Plug 'mattn/emmet-vim'

" Jade support
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }

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

"C/C++ tools"
Plug 'justmao945/vim-clang', { 'for': [ 'c', 'c++' ] }

" Fuzzy finder for files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Javascript support
Plug 'othree/yajs.vim'
Plug 'mxw/vim-jsx'
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'marijnh/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }

" Swift
Plug 'keith/swift.vim'

" Better grep
Plug 'rking/ag.vim'

" Add CopyRTF Command
Plug 'zerowidth/vim-copy-as-rtf'

" toml support
Plug 'cespare/vim-toml'

call plug#end()

" Configure color scheme
set background=dark
let g:seoul256_background = 233
color seoul256

" Setup status bar to work with OSX Terminal.app
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep=''
let g:airline_right_sep=''

" C/C++ completion config
let g:clang_c_options = '-std=gnu11'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'

" Custom mapping the file finders
nnoremap <leader>i :FZF<CR>
nnoremap <leader>/ :Ag<space>-i<space>
nnoremap <leader>o <c-w><c-o>

" merge commands (diff)
vnoremap dp :diffput<CR>:diffupdate<CR>
nnoremap dp :diffput<CR>:diffupdate<CR>
nnoremap dg :diffget<CR>:diffupdate<CR>

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
" merge commands (diff) speficif to fugitive merge
nnoremap dh :diffget //2<CR>:diffupdate<CR>
nnoremap dl :diffput //3<CR>:diffupdate<CR>
" Map <C-n>/<C-p> to next/previous change
au FilterWritePre * if &diff | exe 'nnoremap <buffer> <C-p> [c' | exe 'nnoremap <buffer> <C-n> ]c' | endif

" Configuration sor Syntactic
let g:syntastic_javascript_checkers = [ 'eslint' ]

" Avoid conflict between fugitive and editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" TypeScript compiler options
let g:typescript_compiler_options = '-sourcemap'

" Tern mappings
nnoremap td :TernDoc<CR>
nnoremap t<S-d> :TernDef<CR>
nnoremap tt :TernType<CR>
nnoremap tr :TernRename<CR>
nnoremap t<S-r> :TernRefs<CR>

" Golang support
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1

" Space completion
inoremap <C-@> <c-x><c-o>

" Completion using Tab (from Gay Bernhardt's vimrc)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Emmet
let g:user_emmet_complete_tag = 1
let g:user_emmet_install_global = 0
let g:user_emmet_expandabbr_key = '<C-@>'
autocmd FileType html,css,scss,eruby EmmetInstall
autocmd FileType html,css,scss,eruby imap <buffer> <expr> <C-@> emmet#expandAbbrIntelligent("\<C-@>")

" Terminal config
if has("nvim")
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-l> <C-\><C-n><C-w>l
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-h> <C-\><C-n><C-w>h
  nnoremap <leader><S-t> :terminal zsh<CR>
  nnoremap <BS> <c-w>h
end

" Enable jsx in js files
let g:jsx_ext_required = 0
