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

"""""""" keep package manager up-to-date
NeoBundleFetch 'Shougo/neobundle.vim'

"""""""" plugins
source $HOME/.vimpackages

"""""""" color scheme
NeoBundle 'altercation/vim-colors-solarized'

NeoBundleCheck
filetype plugin indent on

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMON EDITOR OPTIONS
" (no .swp, buffers/tabs options etc. mostly from Gary Bernhart's .vimrc)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable syntax highlighting
syntax on
" cowboy mode on
set nocompatible
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
" AVOID EOL WHITESPACES
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" MACROS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GARY BENRHART's Rspec macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

let g:test_allow_bundle=0
function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    if match(a:filename, '\.feature$') != -1
      if !empty(glob('.zeus.sock')) && !empty(a:filename)
        exec ":!zeus cucumber " . a:filename
      else
        if g:test_allow_bundle && filereadable("Gemfile")
            exec ":!bundle exec cucumber " . a:filename
        else
            exec ":!cucumber " . a:filename
        end
      end
    else
      if !empty(glob('.zeus.sock')) && !empty(a:filename)
        exec ":!zeus test " . a:filename
      else
        if g:test_allow_bundle && filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
      end
    end
endfunction
