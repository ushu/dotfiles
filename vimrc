" vim:set ts=2 sts=2 sw=2 expandtab:

" sensible defaults
set encoding=utf-8
set nocompatible
set novisualbell
set backspace=indent,eol,start
set shell=bash
" speed settings -> avoids that vim eats all your RAM...
set lazyredraw
set synmaxcol=256
" define leader
let mapleader=","
" file name completion
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

" Indent config
filetype plugin indent on
" defaults => 2-spaces wide
set autoindent
set tabstop=2 softtabstop=0 shiftwidth=2
set expandtab smarttab

" Plugins
function! LoadPlugins()
  call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-fugitive'
  Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
  Plug 'mxw/vim-jsx', { 'for': 'javascript' }
  Plug 'mattn/emmet-vim', { 'for': [ 'html', 'javascript' ] }
  Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
  Plug 'fatih/vim-go', { 'for': 'go', 'on': 'GoImports' }
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'w0rp/ale'
  Plug '/usr/local/opt/fzf', { 'on': [ 'FZF', 'Ag', 'Buffers', 'BCommits', 'Commits' ] }
  Plug 'junegunn/fzf.vim', { 'on': [ 'FZF', 'Ag', 'Buffers', 'BCommits', 'Commits' ] }
  Plug 'elixir-editors/vim-elixir', { 'for': 'elixir' }
  Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
  " Completion
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'wokalski/autocomplete-flow', { 'for': [ 'javascript', 'jsx' ] }
  Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }
  Plug 'https://github.com/zchee/deoplete-go', { 'for': 'go' }
  call plug#end()
  autocmd BufWrite *.go :GoImports
endfunction
call LoadPlugins()

" Activate syntaxes on specific files
augroup SyntaxEx
  autocmd! BufRead Brewfile,Gemfile,Podfile,VagrantFile,Cheffile setlocal ft=ruby
  autocmd! BufNewFile,BufRead .pryrc,*.jbuilder setlocal filetype=ruby
  autocmd! BufNewFile,BufRead *.ts setlocal filetype=typescript
  autocmd! BufNewFile,BufRead *.ex,*.exs,*.eex setlocal filetype=elixir
augroup END

" Custom mappings
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
nnoremap <leader>s <C-w>s
nnoremap <leader>v <C-w>v
nnoremap <leader>d <C-w>c
nnoremap <leader>j :lprev<CR>
nnoremap <leader>l :lnext<CR>
" open FZF for completion
nnoremap <leader>i :FZF<CR>
let g:fzf_history_dir = '~/.local/share/fzf-history'
" open Ag for grepping
nnoremap <leader>/ :Ag<CR>
" other FZF mappings
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>c :BCommits<CR>
nnoremap <leader><S-c> :Commits<CR>
" Git commands (starting with `g`)
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gp :Gpush<space>
nnoremap gc :Gcommit<CR>
nnoremap gd :Gdiff<CR>

" Emmet expand with <TAB>
let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
  \     'extends' : 'jsx',
  \  },
  \}
" lots of ALE config
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 
let g:ale_linters = {
  \   'jsx': ['flow'],
  \   'javascript': ['flow'],
  \ }
let b:ale_fixers = {
  \   'jsx': ['prettier'],
  \   'javascript': ['prettier'],
  \}
let g:ale_fix_on_save = 1
" make Fugitive use AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
" Enable Deoplete on first edit
autocmd! InsertEnter * call deoplete#enable()
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
let g:deoplete#num_processes = 8



