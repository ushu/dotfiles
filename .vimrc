" vim:set ts=2 sts=2 sw=2 expandtab:
" My .vimrc, with a lot coming from Gary Bernhart's vimrc

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

"""""""" keep package manager up-to-date
NeoBundleFetch 'Shougo/neobundle.vim'
"""""""" syntaxes
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'othree/html5.vim'
NeoBundle 'lunaru/vim-less'
NeoBundle 'tpope/vim-cucumber'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'jtratner/vim-flavored-markdown'
NeoBundle 'rodjek/vim-puppet'
"""""""" plugins
" latest versions of default plugins
NeoBundle 'matchit.zip'
NeoBundle 'netrw.vim'
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
" Unite for search/completion
NeoBundle 'Shougo/vimproc', { 'build': {
      \   'windows': 'make -f make_mingw32.mak',
      \   'cygwin': 'make -f make_cygwin.mak',
      \   'mac': 'make -f make_mac.mak',
      \   'unix': 'make -f make_unix.mak',
      \ } }
" unite + plugins
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'depends' : 'Shougo/vimproc',
      \   'autoload' : {
      \       'commands' : [ "Unite", "UniteWithCursorWord" ]
      \   }
      \}
NeoBundleLazy 'Shougo/vimshell', {
      \ 'depends' : 'Shougo/vimproc',
      \ 'autoload' : {
      \   'commands' : [{ 'name' : 'VimShell',
      \                   'complete' : 'customlist,vimshell#complete'},
      \                 'VimShellExecute', 'VimShellInteractive',
      \                 'VimShellTerminal', 'VimShellPop']
      \ }}
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : {
      \ 'unite_sources' : 'outline',
      \ }}
NeoBundle 'tsukkee/unite-tag', { 'autoload' : {
      \ 'unite_sources' : 'tag',
      \ }}
"NeoBundle 'thinca/vim-unite-history'
" file explorer
NeoBundleLazy 'Shougo/vimfiler', {
      \ 'depends' : 'Shougo/vimproc',
      \ 'autoload' : {
      \   'commands' : [ 'VimFiler' ]
      \ }}
" color parenthesis
NeoBundle 'amdt/vim-niji'
" a lot of iabbrev for common errors
NeoBundle 'chip/vim-fat-finger'
" smart parenthesis
NeoBundle 'kana/vim-smartinput'
" emmet
NeoBundle 'mattn/emmet-vim'
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
" Unite
" https://github.com/ujihisa/config/blob/master/_vimrc
let s:file_rec_ignore_pattern=
 \'\%(^\|/\)\.$\|\~$\|\.\%(o\|exe\|dll\|ba\?k\|sw[po]\|tmp\|png\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|node_modules\|vendor/bundle\|public/assets\|app/assets/images'
call unite#custom#source('file_rec', 'ignore_pattern', s:file_rec_ignore_pattern)
call unite#custom#source('grep', 'ignore_pattern', s:file_rec_ignore_pattern)
" https://raw.github.com/Shougo/shougo-s-github/master/vim/.vimrc
call unite#custom#source('file_rec', 'sorters', 'sorter_reverse')
call unite#custom#source(
      \ 'buffer,file_rec,file_rec/async,file_mru', 'matchers',
      \ ['converter_tail', 'matcher_fuzzy'])
call unite#custom#source(
      \ 'file', 'matchers',
      \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
call unite#custom#source(
      \ 'file_rec/async,file_mru', 'converters',
      \ ['converter_file_directory'])
call unite#filters#sorter_default#use(['sorter_rank'])
let g:unite_source_file_rec_max_cache_files = 1000
"let g:unite_source_history_yank_enable = 1
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

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
  autocmd! BufRead,BufNewFile *.json setlocal filetype=javascript
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
" Unite
nnoremap <C-p> <C-l>:Unite -start-insert -immediately file_rec/async buffer<cr>
nnoremap <C-i> <C-l>:Unite -resume file_rec/async buffer<cr>
nnoremap <leader>/ :Unite grep:.<cr>
nnoremap <leader>. :Unite history/yank<cr>
nnoremap <leader>m :Unite outline<cr>
nnoremap <leader>] :UniteWithCursorWord tag<cr>
" emmet starts with Ctrl-Space on the Mac
let g:user_emmet_leader_key = ','
let g:user_emmet_expandabbr_key = '<C-@>'
" retrying fugitive :)
" added a bunch of gX commands, overriding existing shortcuts..
" ( but I don't want to depend on <leader> !)
nnoremap g<Space> :Git<Space>
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gb :Gblame<CR>
nnoremap gd :Gdiff<CR>
" pop shell
:nmap <leader><space> :VimShellPop<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HANDLING THE EMPTY LINES END OEL SPACES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color in rend EOL spaces and empty lines
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VERY fast Tab completion from Gary Bernhart's vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
     return "\<C-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" and change the mapping to hit emmet in HTML/CSS files
function! CallEmmet()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
     return "\<c-g>u\<esc>:call emmet#expandAbbr(0,\"\")\<cr>a"
  endif
endfunction
autocmd FileType html,eruby,css,scss inoremap <buffer> <tab> <c-r>=CallEmmet()<cr>
autocmd FileType html,eruby,css,scss map <buffer> <c-n> <leader>n

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clear the search buffer when hitting return
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction

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
