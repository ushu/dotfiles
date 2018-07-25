" vim:set ts=2 sts=2 sw=2 expandtab:

" sensible defaults
set encoding=utf-8
set nocompatible
set novisualbell
set backspace=indent,eol,start
set shell=bash
set wildmode=longest,list,full

" Allow multiple edition on a file
set nobackup
set noswapfile
set hidden

" Colors
syntax on
colorscheme desert

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
let g:netrw_liststyle = 3

" indent size
set tabstop=2|set shiftwidth=2|set expandtab
autocmd FileType go set tabstop=4|set shiftwidth=4|set noexpandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab

" Custom types for config files
augroup SyntaxEx
  autocmd! BufRead Brewfile,Gemfile,Podfile,VagrantFile,Cheffile setlocal ft=ruby
  autocmd! BufNewFile,BufRead .pryrc,*.jbuilder setlocal filetype=ruby
  autocmd! BufNewFile,BufRead *.ts setlocal filetype=typescript
  autocmd! BufNewFile,BufRead *.ex,*.exs,*.eex setlocal filetype=elixir
augroup END

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
map <leader>i :e **/*
set wildmenu
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*


