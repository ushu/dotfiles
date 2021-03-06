" vim:set ts=2 sts=2 sw=2 expandtab:

" sensible defaults
set encoding=utf-8
set nocompatible
" set visualbell
" set cursorline
set backspace=indent,eol,start
set shell=bash
set wildmode=longest,list,full
set visualbell
set updatetime=300
set textwidth=72
set shortmess+=I

" Allow multiple edition on a file
set nobackup
set noswapfile
set hidden

" (from the docs) Jump to last cursor position 
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" Enable indent & plugins
filetype plugin indent on
" & config default plugins
let g:loaded_matchparen = 1
let g:netrw_banner = 0
let g:ale_sign_column_always = 1

" indent size
set tabstop=2
set shiftwidth=2
set expandtab
autocmd FileType go setlocal tabstop=4|set shiftwidth=4|set noexpandtab
autocmd FileType python setlocal tabstop=4|set shiftwidth=4|set expandtab

" Custom types for config files
augroup SyntaxEx
  autocmd BufNewFile,BufRead Appfile,Fastfile,Brewfile,Gemfile,Podfile,VagrantFile,Cheffile setlocal ft=ruby
  autocmd BufNewFile,BufRead Procfile setlocal ft=yaml
  autocmd BufNewFile,BufRead .prettierrc setlocal ft=json
  autocmd BufNewFile,BufRead .pryrc,*.jbuilder setlocal filetype=ruby
  autocmd BufNewFile,BufRead .gitconfig* setlocal filetype=gitconfig
  autocmd BufNewFile,BufRead *.plist setlocal filetype=xml
augroup END

if filereadable("~/.dotfiles/plugins.vim")
  source "~/.dotfiles/plugins.vim"
endif

" Colors
syntax on
try
  colorscheme monokai_pro
catch
  colorscheme desert
endtry

" Custom mappings
let mapleader=","

" <leader><leader> => previous buffer
nnoremap <leader><leader> <C-^>
" %% expands to current directory
cnoremap %% <C-R>=expand('%:h').'/'<CR>
" <leader>e => open current directory
map <leader>e :e %%<CR>
" <leader>a => open location list
map <leader>a :lopen<CR>
" <C-hjkl> => move among windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" splits s=horizontal / v = vertical / d = close
nnoremap <leader>s <C-w>s
nnoremap <leader>v <C-w>v
nnoremap <leader>d <C-w>c
" <leader><leader> => previous buffer
nnoremap <leader><leader> <C-^>
" %% expands to current directory
cnoremap %% <C-R>=expand('%:h').'/'<CR>
" <leader>e => open current directory
map <leader>e :e %%<CR>
" <leader>i => open w/ prefix for fuzzy search
if filereadable("/usr/local/opt/fzf/plugin/fzf.vim")
  "source /usr/local/opt/fzf/plugin/fzf.vim
  map <leader>i :FZF<CR>
  map <leader>/ :Ag<CR>
  map <leader>l :Lines<CR>
  map <leader>o :Tags<CR>
else
  " manual "search" -> not so good... but kinda does the job
  map <leader>i :e **/*
  set wildmenu
  set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
  set wildignore+=*.pdf,*.psd
  set wildignore+=node_modules/*,bower_components/*
endif
nnoremap gs :Gstatus<CR>
nnoremap gl :Glog<CR><CR>:copen<CR><CR>
nnoremap <S-z> za

" Symbol renaming.
nmap <leader>r <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
