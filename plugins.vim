" vim:set ts=2 sts=2 sw=2 expandtab:

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install plugins using https://github.com/kristijanhusak/vim-packager
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " more syntaxes
  call packager#add('sheerun/vim-polyglot')
  call packager#add('neoclide/vim-jsx-improve')
  " fuzzy file search
  call packager#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  call packager#add('junegunn/fzf.vim')
  " completion
  call packager#add('dense-analysis/ale')
  call packager#add('neoclide/coc.nvim', { 'do': function('InstallCoc') })
  " git client
  call packager#add('tpope/vim-fugitive')
  " Go stuff
  call packager#add('fatih/vim-go', { 'do': ':GoInstallBinaries', 'type': 'opt' })
  " color scheme
  call packager#add('phanviet/vim-monokai-pro')
  " DB Utils
  call packager#add('tpope/vim-dadbod')
  call packager#add('kristijanhusak/vim-dadbod-ui')
endfunction

" COC-specific setup (install extensions)
function! InstallCoc(plugin) abort
  exe '!cd '.a:plugin.dir.' && yarn install'
  CocInstall coc-tsserver coc-python coc-snippets coc-eslint coc-json coc-rls coc-emmet coc-html coc-prettier
  call coc#add_extension('coc-eslint', 'coc-tsserver', 'coc-python', 'coc-snippets')
endfunction

" Lazy-loaded plugins
augroup packager_filetype
  autocmd!
  autocmd FileType go packadd vim-go
augroup END

" Custom commands for package manager
command! PackagerInstall call PackagerInit() | call packager#install()
command! -bang PackagerUpdate call PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COC-specific config(s)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" configure <TAB> for COC 
" (copied from the docs, no idea what it actually does...)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DB (UI) config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load DB config from env
let g:db_ui_env_variable_url = 'DATABASE_URL'
let g:db_ui_env_variable_name = 'DATABASE_NAME'

" RENAME CURRENT FILE (from Gary Bernhardt's .vimrc)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

