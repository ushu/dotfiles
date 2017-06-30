" vim:set ts=2 sts=2 sw=2 expandtab:

" sensible defaults
set encoding=utf-8
set nocompatible
let mapleader=","

" Allow multiple edition on a file
set nobackup
set noswapfile
set hidden
set visualbell

" (from the docs) Jump to last cursor position 
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

" Highlighting is ON
syntax on
filetype plugin indent on

" Indent & spacing (defaults => usually overriden by editorconfig plugin)
set autoindent
set tabstop=2 softtabstop=0 expandtab shiftwidth=4 smarttab
set expandtab

" Avoid some anoying vim behaviours
set backspace=indent,eol,start
set shell=bash

" Load theme
let g:seoul256_background=233
color seoul256

" <leader>i => fuzzy finder
nnoremap <leader>i :FZF<CR>
" <leader>/ => Better grep using silver searcher
nnoremap <leader>/ :Ag<space>-i<space>

" <C-hjkl> => move among windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>s <C-w>s
nnoremap <leader>v <C-w>v
nnoremap <leader>c <C-w>c
nnoremap <leader>d <C-w>c
nnoremap <leader>j :lprev<CR>
nnoremap <leader>l :lnext<CR>

" Git
nnoremap gs :Gstatus<CR>
nnoremap ga :Gadd<CR>
nnoremap gc :Gcommit<CR>
nnoremap gd :Gdiff<CR>

" navigation
" <leader><leader> => previous buffer
nnoremap <leader><leader> <C-^>
" %% expands to current directory
cnoremap %% <C-R>=expand('%:h').'/'<CR>
" <leader>e => open current directory
map <leader>e :e %%<CR>
" <leader>a => open location list
map <leader>a :lopen<CR>

" (recommended) conf for syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0

" (recommended) config for completor
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

" Fix editorconfig + elixir
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" (recommended) config for validator
" load clang-tidy from cellar: it installed via homebrew but not linked to
" avoid comflcting w/ Apple build system
let g:clang_cellar_path = system("brew --prefix llvm")
let g:validator_clang_tidy_binary = g:clang_cellar_path . "/bin/clang-tidy"
" prefer eslint for JS
let g:validator_javascript_checkers = ['eslint']

