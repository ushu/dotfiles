" vim:set ts=2 sts=2 sw=2 expandtab:

" sensible defaults
syntax on
set encoding=utf-8
set nocompatible
let mapleader=","
set novisualbell

" Allow multiple edition on a file
set nobackup
set noswapfile
set hidden

" Color
colorscheme desert

" Load Plugins
call plug#begin('~/.config/nvim/plugged')

" Uses fzy+Ag to provider "fuzzy" opening and grepping
Plug 'cloudhead/neovim-fuzzy', { 
			\ 'on':  [ 'FuzzyOpen' , 'FuzzyGrep' ],
			\ 'do': 'brew install fzy the_silver_searcher',
			\ }

" Git support
Plug 'tpope/vim-fugitive'

" Split terminal support
"Plug 'mklabs/split-term.vim'

" Linter
Plug 'w0rp/ale'

" Bottom line
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

" Go support + tools
Plug 'fatih/vim-go', { 
      \ 'for': 'go',
      \ 'do': ':GoInstallBinaries' 
      \ }

" Snippets support
Plug 'mattn/emmet-vim'
"Plug 'SirVer/ultisnips'
"Plug 'jceb/emmet.snippets'

" Completion plugin
Plug 'roxma/nvim-completion-manager', {
      \ 'do': 'pip3 install --user neovim jedi psutil setproctitle'
      \ }
Plug 'Shougo/neco-syntax'
Plug 'othree/csscomplete.vim', { 'for': 'css' }
Plug 'roxma/ncm-clang', { 'for': [ 'c', 'cpp' ] }
Plug 'calebeby/ncm-css', { 'for': [ 'css', 'scss' ] }
Plug 'mhartington/nvim-typescript', { 'for': 'typescript' }
Plug 'roxma/nvim-cm-racer', { 
      \ 'for': 'rust',
      \ 'do': 'cargo install racer',
      \ }
Plug 'roxma/ncm-flow', { 'for': 'javascript' }
Plug 'roxma/ncm-elm-oracle', { 
      \ 'for': 'elm',
      \ 'do': 'yarn global add elm-oracle',
      \ }

" Ton of syntaxes
Plug 'sheerun/vim-polyglot'
Plug 'rhysd/vim-gfm-syntax', { 'for': 'markdown' }

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

" Javascript
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }

" Typescript
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }

call plug#end()

"
" Plugin-specific config
"

" Live lint settings
let g:ale_sign_error = '☠'
let g:ale_sign_warning = '🐛'
"let g:ale_sign_column_always = 1
let g:ale_change_sign_column_color=1

" select completions with <tab>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" overload omnicomplete for CSS
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
autocmd FileType html setlocal omnifunc=emmet#completeTag

let g:user_emmet_expandabbr_key='<Tab>'
autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")


" colorscheme for the bottom line
let g:lightline = { 'colorscheme': 'landscape' }

" load individual plugins
let g:polyglot_disabled = ['rust', 'javascript', 'typescript', 'go', 'markdown']

"
" More syntaxes
"

autocmd BufRead Brewfile,Gemfile setlocal ft=ruby
autocmd BufRead *.md setlocal ft=markdown

"
" Custom mappings
"

" open file (fuzzy)
nnoremap <leader>i :FuzzyOpen<CR>
" grep current dir (fuzzy)
nnoremap <leader>/ :FuzzyGrep<CR>

command! Term exe "term" | startinsert
command! Sterm split | exe "term" | startinsert
nnoremap <leader>r :Term<CR>
" start mutt
command! Mail exe "term mutt" | startinsert | tnoremap <buffer> <C-i> <C-\><C-n>
command! Smail below new | exe "term mutt" | startinser | tnoremap <buffer> <C-i> <C-\><C-n>t
nnoremap <leader>m :Mail<CR>


" navigation
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

" force <tab>
inoremap <S-Tab> <C-V><Tab>

" escape terminal w/ <C-i>
tnoremap <C-i> <C-\><C-n>

" Git commands (starting with `g`)
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gd :Gdiff<CR>

