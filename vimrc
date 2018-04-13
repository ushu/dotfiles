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
  Plug 'othree/yajs.vim', { 'for': 'javascript' }
  Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }
  Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
  Plug 'fatih/vim-go', { 'for': 'go', 'on': 'GoImports' }
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'vim-syntastic/syntastic'
  call plug#end()
  autocmd BufWrite *.go :GoImports
endfunction
command! LoadPlugins :call LoadPlugins()

" Activate syntaxes on specific files
augroup SyntaxEx
  autocmd! BufRead Brewfile,Gemfile,Podfile,VagrantFile,Cheffile setlocal ft=ruby
  autocmd! BufNewFile,BufRead .pryrc,*.jbuilder setlocal filetype=ruby
  autocmd! BufNewFile,BufRead *.ts setlocal filetype=typescript
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
" <tab> hacks
" 1. tab-based completion (from Gary Bernhardt's vimrc)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
" 2. <S-Tab> to "force" <TAB> char inclusion
inoremap <S-Tab> <C-V><Tab>
" Git commands (starting with `g`)
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gd :Gdiff<CR>


