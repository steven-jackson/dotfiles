set nocompatible

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:python3_host_prog = '/usr/bin/python'

set sw=4 expandtab
set smartindent
set smarttab
set relativenumber
set cursorline
set showmatch
set ignorecase
set smartcase
set colorcolumn=80
set breakindent
set diffopt=vertical
set clipboard=unnamed
set fileformat=unix
set fileformats=unix,dos
set noreadonly

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'morhetz/gruvbox'
Plug 'kien/ctrlp.vim'
Plug 'Shougo/neosnippet.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'neomake/neomake'
Plug 'markonm/traces.vim'

Plug 'rust-lang/rust.vim'

" Auto-check/format, etc.
Plug 'dense-analysis/ale'
Plug 'keith/swift.vim'

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

if !has("macunix")
    set termguicolors
endif

set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = "soft"

" ctrlp
let g:ctrlp_custom_ignore = {
    \ 'dir': 'target',
    \ 'file': 'Cargo.lock',
    \ }

" vim-aline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "hybrid"
let g:airline_powerline_fonts = 1

" neomake
let g:neomake_open_list = 2
" call neomake#configure#automake('nrwi', 1000)

" Personal
let mapleader = ","
nnoremap <F2> :bp<CR>
nnoremap <F3> :bn<CR>

" Escape terminal mode
tnoremap <leader><Esc> <C-\><C-n>

" rust
let g:rustfmt_autosave = 1
let g:ale_rust_cargo_use_clippy = 1

" neosnippet
let g:neosnippet#disable_runtime_snippets = { "_": 1, }
let g:neosnippet#snippets_directory='~/.dotfiles/snippets'
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" coc.nvim ===================================================================

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
