" vim:set ts=2 sts=2 sw=2 expandtab:

set encoding=utf-8
let mapleader=","

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LOAD PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load package manager
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

" NeoBundle lazyloading
" NeoBundleLazy 'github/repo', {
"       \ 'build': {
"       \   'windows': 'make -f make_mingw32.mak',
"       \   'cygwin': 'make -f make_cygwin.mak',
"       \   'mac': 'make -f make_mac.mak',
"       \   'unix': 'make -f make_unix.mak',
"       \ },
"       \ 'depends' : 'other/bundle',
"       \ 'autoload' : {
"       \   'commands' : [
"       \     'Command',
"       \     'OtherCommand'
"       \   ],
"       \   'mappings' : '<c-p>',
"       \   'insert' : 1,
"       \   'filetypes' : [ 'html', 'css', 'sass', 'eruby']
"       \ }
"       \ }

"""""""" keep package manager up-to-date
NeoBundleFetch 'Shougo/neobundle.vim'
"""""""" syntaxes
NeoBundleLazy 'pangloss/vim-javascript', {
      \   'autoload': {
      \     'filetypes': 'javascript'
      \ } }
NeoBundleLazy 'othree/html5.vim', {
      \   'autoload': {
      \     'filetypes': 'html'
      \ } }
NeoBundleLazy 'lunaru/vim-less', {
      \   'autoload': {
      \     'filetypes': 'less'
      \ } }
NeoBundleLazy 'tpope/vim-cucumber'
NeoBundleLazy 'cakebaker/scss-syntax.vim', {
      \   'autoload': {
      \     'filetypes': 'scss'
      \ } }
NeoBundleLazy 'kchmck/vim-coffee-script', {
      \   'autoload': {
      \     'filetypes': 'coffee'
      \ } }
NeoBundle 'jtratner/vim-flavored-markdown', {
      \   'autoload': {
      \     'filetypes': 'ghmarkdown'
      \ } }
"NeoBundle 'rodjek/vim-puppet'
"""""""" plugins
" better status line
NeoBundle 'bling/vim-airline'
" smart syntax checker
NeoBundle 'scrooloose/syntastic'
" connect to Gist
NeoBundleLazy 'mattn/webapi-vim'
NeoBundleLazy 'mattn/gist-vim', {
      \   'depends': 'mattn/webapi-vim',
      \   'autoload': {
      \     'commands': [ 'Gist' ]
      \ } }
NeoBundleLazy 'kien/ctrlp.vim', {
      \   'autoload' : {
      \       'commands' : [ 'CtrlP' ],
      \   }
      \}
" emmet
NeoBundleLazy 'mattn/emmet-vim', {
      \ 'autoload' : {
      \   'insert' : 1,
      \   'filetypes' : [ 'html', 'css', 'sass', 'eruby'],
      \ } }
" solarized color scheme
NeoBundle 'altercation/vim-colors-solarized'
" Git fugitive
NeoBundle 'tpope/vim-fugitive'

NeoBundleCheck

" enable everything
filetype plugin indent on
syntax on

colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAKE TERMINAL.APP HAPPY
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" solarized with fix for Terminal.app https://github.com/altercation/solarized/issues/146
if has('gui_macvim')
  set transparency=0
endif
if !has('gui_running') && $TERM_PROGRAM == 'Apple_Terminal'
  let g:solarized_termcolors = &t_Co
  let g:solarized_termtrans = 1
  colorscheme solarized
endif

" fix ugly airline in Terminal.app
let g:airline_left_sep=''
let g:airline_right_sep=''

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPTIONS FOR PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""" Syntastic
" use google's gslint
let g:syntastic_javascript_checkers = ['gjslint', 'jslint']
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules$|vendor',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }

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
set history=1000
set laststatus=2
" search options
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set switchbuf=useopen
set numberwidth=5
set winwidth=79
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
"set scrolloff=3
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
" make shell work with Rails
set shell=bash

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
  autocmd! BufRead,BufNewFile *.scss setlocal filetype=scss
  autocmd! BufRead,BufNewFile *.coffee setlocal filetype=coffee
  autocmd! BufRead,BufNewFile *.less setlocal filetype=less
  autocmd! BufRead,BufNewFile *.json setlocal filetype=javascript
  autocmd! BufRead,BufNewFile *.feature setlocal filetype=cucumber
  autocmd! BufRead,BufNewFile Gemfile,Procfile,Podfile,VagrantFile setlocal filetype=ruby
  autocmd! BufRead,BufNewFile .pryrc setlocal filetype=ruby
  " replace markdown by github markdown everywhere
  autocmd! BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown

  " auto removing of ending spaces
  autocmd FileType ruby,python,javascript,sh autocmd BufWritePre <buffer> :%s/\s\+$//e

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
" emmet starts with Ctrl-e on the Mac
let g:user_emmet_leader_key = ','
let g:user_emmet_expandabbr_key = '<C-e>'
" retrying fugitive :)
" added a bunch of gX commands, overriding existing shortcuts..
" ( but I don't want to depend on <leader> !)
nnoremap g<Space> :Git<Space>
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gb :Gblame<CR>
nnoremap gd :Gdiff<CR>
" CtrlP
nnoremap <c-p> :CtrlP<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HANDLING THE EMPTY LINES END OEL SPACES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color in rend EOL spaces and empty lines
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" VERY fast Tab completion from Gary Bernhart's vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clear the search buffer when hitting return
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
 call MapCR()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GARY BENRHART's macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" promote to let
function! PromoteToLet()
  :normal! dd
" :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>

" test files
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    if match(a:filename, '\.feature$') != -1
      if !empty(glob('.zeus.sock')) && !empty(a:filename)
        exec ":!zeus cucumber " . a:filename
      else
        if filereadable("Gemfile")
            exec ":!bundle exec cucumber " . a:filename
        else
            exec ":!cucumber " . a:filename
        end
      end
    else
      if !empty(glob('.zeus.sock')) && !empty(a:filename)
        exec ":!zeus rspec " . a:filename
      else
        if filereadable("Gemfile")
            exec ":!bundle exec rspec -fd --color " . a:filename
        else
            exec ":!rspec -fd --color " . a:filename
        end
      end
    end
endfunction
