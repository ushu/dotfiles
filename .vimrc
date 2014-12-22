" vim:set ts=2 sts=2 sw=2 expandtab:

set encoding=utf-8
let mapleader=","

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LOAD PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load package manager
if has('vim_starting')
  if &compatible
    set nocompatible
  endif

  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))

" keep package manager up-to-date
NeoBundleFetch 'Shougo/neobundle.vim'

" Allow vim to run processes
NeoBundleLazy 'Shougo/vimproc', { 'build': {
     \ 'windows': 'make -f make_mingw32.mak',
     \ 'cygwin': 'make -f make_cygwin.mak',
     \ 'mac': 'make -f make_mac.mak',
     \ 'unix': 'make -f make_unix.mak',
     \ }}

" editorconfig (reads ~/.editorconfig)
NeoBundle 'editorconfig/editorconfig-vim'

" A better status bar
NeoBundle 'bling/vim-airline'

" Git support
NeoBundle 'tpope/vim-fugitive'

" lazy-loaded plugins by file type
NeoBundleLazy 'scrooloose/syntastic', { 'autoload' : {
       \ 'filetypes' : [ 'ruby', 'eruby', 'javascript', 'cucumber', 'coffee', 'go' ] }}
NeoBundleLazy 'mattn/emmet-vim', { 'autoload' : {
       \ 'insert' : 1,
       \ 'filetypes' : [ 'html', 'css', 'sass', 'eruby'] }}
NeoBundleLazy 'fatih/vim-go', { 'autoload' : {
       \ 'filetypes' : [ 'go' ],
       \ 'commands' : [ 'GoInstallBinaries' ] }}

" lazy-loaded plugins by command
NeoBundleLazy 'Shougo/vimshell', {
      \ 'depends' : 'Shougo/vimproc',
      \ 'autoload' : {
      \  'commands' : [ { 'name' : 'VimShell',
      \                  'complete' : 'customlist,vimshell#complete' },
      \                  'VimShellExecute', 'VimShellInteractive',
      \                  'VimShellTerminal', 'VimShellPop' ] }}
NeoBundleLazy 'scrooloose/nerdtree', { 'autoload' : {
       \ 'commands' : [ 'NERDTreeToggle' ] }}
NeoBundleLazy 'kien/ctrlp.vim', { 'autoload' : {
       \ 'commands' : [ 'CtrlP' ] }}
NeoBundleLazy 'zerowidth/vim-copy-as-rtf', { 'autoload' : {
       \ 'commands' : [ 'CopyRTF' ] }}
NeoBundleLazy 'majutsushi/tagbar', { 'autoload': {
       \ 'commands' : [ 'TagbarToggle' ] }}

" Unite
NeoBundle 'Shougo/unite.vim', {
      \ 'depends' : 'vimproc',
      \ 'autoload' : {
      \ 'commands' : [ "Unite", "UniteWithCursorWord" ]
      \ }}
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : { 'unite_sources': 'outline' }}
NeoBundleLazy 'kmnk/vim-unite-giti', { 'autoload' : { 'unite_sources': [ 'giti', 'git/branch', 'git/config', 'git/log', 'git/remote', 'git/status' ] }}

" NeoComplete
NeoBundle 'Shougo/neocomplete.vim', {
      \ 'depends' : 'vimproc',
       \ 'insert' : 1 }
NeoBundle 'Shougo/neosnippet.vim', {
      \ 'depends' : 'neocomplete.vim',
       \ 'insert' : 1 }
NeoBundle 'Shougo/neosnippet-snippets', {
      \ 'depends' : 'neosnippet.vim',
       \ 'insert' : 1 }

" custom syntax coloring
NeoBundleLazy 'pangloss/vim-javascript', {'autoload': { 'filetypes': 'javascript'}}
NeoBundleLazy 'othree/html5.vim', {'autoload': {'filetypes': 'html'}}
NeoBundleLazy 'lunaru/vim-less', {'autoload': {'filetypes': 'less'}}
NeoBundleLazy 'tpope/vim-cucumber', {'autoload': {'filetypes': 'feature'}}
NeoBundleLazy 'cakebaker/scss-syntax.vim', {'autoload': {'filetypes': 'scss'}}
NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload': {'filetypes': 'coffee'}}
NeoBundleLazy 'plasticboy/vim-markdown', {'autoload': {'filetypes': 'mkd'}}
NeoBundleLazy 'elzr/vim-json', {'autoload': {'filetypes': 'json'}}

" color scheme
NeoBundle 'altercation/vim-colors-solarized'

call neobundle#end()

" finish loading the plugins
filetype plugin indent on

"prompt on uninstalled packages:
NeoBundleCheck

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme solarized

" solarized with fix for Terminal.app https://github.com/altercation/solarized/issues/146
if has('gui_macvim')
  set transparency=0
endif
if !has('gui_running') && $TERM_PROGRAM == 'Apple_Terminal'
  let g:solarized_termcolors = &t_Co
  let g:solarized_termtrans = 1
  colorscheme solarized
endif

" per-extension syntax coloring
augroup syntaxEx

  autocmd! BufRead,BufNewFile *.sass setlocal filetype=sass
  autocmd! BufRead,BufNewFile *.scss setlocal filetype=scss
  autocmd! BufRead,BufNewFile *.coffee setlocal filetype=coffee
  autocmd! BufRead,BufNewFile *.less setlocal filetype=less
  autocmd! BufRead,BufNewFile *.json setlocal filetype=json
  autocmd! BufRead,BufNewFile *.feature setlocal filetype=cucumber
  autocmd! BufRead,BufNewFile Gemfile,Procfile,Podfile,VagrantFile,Cheffile setlocal filetype=ruby
  autocmd! BufRead,BufNewFile .pryrc setlocal filetype=ruby
  autocmd! BufRead,BufNewFile *.go setlocal filetype=go

  " replace markdown by github markdown everywhere
  autocmd! BufNewFile,BufRead *.md,*.markdown setlocal filetype=mkd

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMON EDITOR OPTIONS
" (no .swp, buffers/tabs options etc. mostly from Gary Bernhart's .vimrc)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable syntax highlighting
syntax on
" no backup & swap files
set nobackup
set noswapfile
set hidden
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
" indent mode = autoindent
set autoindent
set nocindent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPTIONS FOR PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:user_emmet_leader_key = ','
let g:user_emmet_expandabbr_key = '<C-@>'

" fugitive
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

" Syntastic
" use google's gslint
let g:syntastic_javascript_checkers = ['gjslint', 'jslint']

" fix ugly airline in Terminal.app
let g:airline_left_sep=''
let g:airline_right_sep=''

" NERD Tree
noremap <c-N> :NERDTreeToggle<cr>
let NERDTreeHijackNetrw=0

" Unite
if executable('ag')
  let g:unite_source_rec_async_command='ag --nocolor --nogroup --skip-vcs-ignores --ignore ''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'' --ignore ''_darcs'' --ignore ''bundle/'' --ignore ''tmp/'' --hidden -g ""'
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif
nnoremap <leader>i :Unite -start-insert file_rec/async:<cr>
nnoremap <leader>b :Unite buffer<cr>
nnoremap <leader>b :Unite buffer<cr>
nnoremap <leader>/ :Unite grep:.<cr>
nnoremap <leader>. :Unite outline<cr>
nnoremap <leader><space> :Unite -start-insert source<cr>

" NeoComplete (recommended settings from GitHub)
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" NeoSnippet
" expand/next with C-j
imap <expr><C-j> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : ""
smap <expr><C-j> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: ""
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Go
augroup AutoMappings
  autocmd FileType go nnoremap <buffer> <leader>r :GoRun<CR>
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RULES TO AVOID EOL WHITESPACES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" color in rend EOL spaces and empty lines
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" auto removing of ending spaces
augroup RemoveEOL
  autocmd FileType ruby,python,javascript,sh,css autocmd BufWritePre <buffer> :%s/\s\+$//e
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ENABLE OMNICOMPLETION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup OmniCompletion

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" (GARY BENRHART's) MACROS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
