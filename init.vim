" vim:set ts=2 sts=2 sw=2 expandtab:

" sensible defaults
set encoding=utf-8
set nocompatible
let mapleader=","
set novisualbell

filetype plugin indent on
"syntax on
autocmd BufEnter syntax on

" Allow multiple edition on a file
set nobackup
set noswapfile
set hidden

"
" Plugins
"

set runtimepath+=~/.config/nvim/plugins/github.com/Shougo/dein.vim
command PlugInstall :call dein#install()
command PlugUpdate :call dein#update()

if dein#load_state(expand('~/.config/nvim/plugins'))
  call dein#begin(expand('~/.config/nvim/plugins'))

  " Auto-update dein
  call dein#add('Shougo/dein.vim')

  " Color theme
  call dein#add('junegunn/seoul256.vim')

  " Git support
  call dein#add('tpope/vim-fugitive')

  " Uses fzy+Ag to provider "fuzzy" opening and grepping
  call dein#add('cloudhead/neovim-fuzzy', { 
        \ 'lazy': '1',
        \ 'on_cmd':  ['FuzzyOpen', 'FuzzyGrep'],
        \ 'build': {
        \   'mac': 'brew install fzy the_silver_searcher'
        \   }
        \ })

  " Linter
  call dein#add('w0rp/ale', {
        \ 'lazy': '1',
        \ 'on_ft': ['sh']
        \ })

  " Status line
  call dein#add('itchyny/lightline.vim')
  call dein#add('maximbaz/lightline-ale')

  " Go support + tools
  call dein#add('fatih/vim-go', { 
        \ 'lazy': '1',
        \ 'on_ft': ['go'],
        \ 'hook_post_update': ':GoInstallBinaries' 
        \ })

  " Emmet for html editing
  call dein#add('mattn/emmet-vim', {
        \ 'lazy': '1',
        \ 'on_ft': ['html'],
        \ })

  " Ton of syntaxes
  call dein#add('sheerun/vim-polyglot', {
        \ 'lazy': '1',
        \ 'on_event': 'BufEnter'
        \})
  call dein#add('rhysd/vim-gfm-syntax', { 
        \ 'lazy': '1',
        \ 'on_ft': 'markdown.gfm'
        \ })

  " Rust
  call dein#add('rust-lang/rust.vim', { 
        \ 'lazy': '1',
        \ 'on_ft': 'rust'
        \ })
  call dein#add('racer-rust/vim-racer', { 
        \ 'lazy': '1',
        \ 'on_ft': 'rust',
        \ 'depends': 'rust.vim'
        \ })

  " Javascript
  call dein#add('othree/yajs.vim', { 
        \ 'lazy': '1',
        \ 'on_ft': 'javascript' 
        \ })
  call dein#add('othree/es.next.syntax.vim', { 
        \ 'lazy': '1',
        \ 'on_ft': 'javascript',
        \ 'depends': 'yajs.vim'
        \ })

  " Typescript
  call dein#add('HerringtonDarkholme/yats.vim', { 
        \ 'lazy': '1',
        \ 'on_ft': 'typescript' 
        \ })

  " Dark-powered completion plugin (lazily-loaded)
  call dein#add('Shougo/deoplete.nvim', {
        \ 'lazy': '1',
        \ 'on_event': 'InsertEnter',
        \ 'build': 'pip3 install --user neovim jedi psutil setproctitle',
        \ 'hook_post_update': ':UpdateRemotePlugins'
        \})
  call dein#add('zchee/deoplete-go', {
        \ 'lazy': '1',
        \ 'build': 'make',
        \ 'on_ft': 'go',
        \ 'depends': 'deoplete.nvim'
        \})
  call dein#add('wokalski/autocomplete-flow', { 
        \ 'lazy': '1',
        \ 'on_ft': 'javascript',
        \ 'depends': 'deoplete.nvim'
        \ })
  call dein#add('mhartington/nvim-typescript', { 
        \ 'lazy': '1',
        \ 'on_ft': 'typescript',
        \ 'depends': 'deoplete.nvim'
        \ })
  call dein#add('zchee/deoplete-jedi', { 
        \ 'lazy': '1',
        \ 'on_ft': 'python',
        \ 'depends': 'deoplete.nvim'
        \ })
  call dein#add('Shougo/neco-vim', { 
        \ 'lazy': '1',
        \ 'on_ft': 'vim',
        \ 'depends': 'deoplete.nvim'
        \ })
  call dein#add('sebastianmarkow/deoplete-rust', { 
        \ 'lazy': '1',
        \ 'on_ft': 'rust',
        \ 'build': 'cargo install --force racer',
        \ 'depends': 'deoplete.nvim'
        \ })
  call dein#add('zchee/deoplete-clang', { 
        \ 'lazy': '1',
        \ 'on_ft': [ 'c', 'cpp' ],
        \ 'build': {
        \   'mac': 'brew install llvm --with-clang'
        \ },
        \ 'depends': 'deoplete.nvim'
        \ })
  call dein#add('pbogut/deoplete-elm', { 
        \ 'lazy': '1',
        \ 'on_ft': 'elm',
        \ 'build': 'yarn global add elm-oracle',
        \ 'depends': 'deoplete.nvim'
        \ })

  call dein#end()
  call dein#save_state()
endif

"
" Color Theme
" 
try
  let g:seoul256_background=233
  colorscheme seoul256

  " colorscheme for the bottom line
  let g:lightline = { 'colorscheme': 'seoul256' }
catch //
  " want some default color if seoul256 not installed
  colorscheme desert
endtry

"
" Plugin-specific config
"

" Live lint settings
let g:ale_sign_error = '☠'
let g:ale_sign_warning = '🐛'
"let g:ale_sign_column_always = 1
let g:ale_change_sign_column_color=1

" select completions with <tab>
let g:deoplete#enable_at_startup = 1
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" overload omnicomplete for HTML/CSS
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
autocmd FileType html setlocal omnifunc=emmet#completeTag

" White space handling for emails in mutt
autocmd FileType mail setlocal fo+=aw

let g:user_emmet_expandabbr_key='<Tab>'
autocmd FileType html imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" load individual plugins
let g:polyglot_disabled = ['rust', 'javascript', 'typescript', 'go', 'markdown']

"
" More syntaxes
"
"
augroup SyntaxEx

  autocmd BufRead Brewfile,Gemfile,Podfile,VagrantFile,Cheffile setlocal ft=ruby
  autocmd! BufNewFile,BufRead .pryrc,*.jbuilder setlocal filetype=ruby
  autocmd! BufNewFile,BufRead *.ts setlocal filetype=typescript
  autocmd BufRead *.md setlocal ft=markdown.gfm

augroup END

"
" Custom mappings
"

" open file (fuzzy)
nnoremap <leader>i :FuzzyOpen<CR>
" grep current dir (fuzzy)
nnoremap <leader>/ :FuzzyGrep<CR>

if has("nvim")
  command! Term exe "term" | startinsert
  command! Sterm split | exe "term" | startinsert
  nnoremap <leader>r :Term<CR>
  " start mutt
  command! Mail exe "term mutt" | startinsert | tnoremap <buffer> <C-i> <C-\><C-n>
  command! Smail below new | exe "term mutt" | startinser | tnoremap <buffer> <C-i> <C-\><C-n>t
  nnoremap <leader>m :Mail<CR>
endif

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

if has("nvim")
  " escape terminal w/ <C-i>
  tnoremap <C-i> <C-\><C-n>
endif

" Git commands (starting with `g`)
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gd :Gdiff<CR>

