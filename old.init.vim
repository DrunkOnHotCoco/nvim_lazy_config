""" let $PATH .= ';C:\Program Files\Git\bin'
"lua require('plugins')
"lua require('init')

""" Main Configurations
filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=2 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set wildmode=longest,list,full wildmenu
"set ruler laststatus=2 showcmd showmode
set wrap breakindent
set encoding=utf-8
set textwidth=0
set hidden
set number
set title
let mapleader=" "
set undofile
set shell=bash
set termguicolors

" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
" set foldmethod=syntax
set foldnestmax=10
set nofoldenable
" set foldlevel=2

"colorscheme NeoSolarized
"colorscheme doom-one

""" Binds
"" coc-clangd (C/C++ Code Completion)
"source $HOME/.config/nvim/coc.vim

" Terminal mode exit
"tnoremap jk <C-\><C-n> 
" Switch buffer in a direction
nnoremap <silent> <Leader>j <c-w>j 
nnoremap <silent> <Leader>k <c-w>k
nnoremap <silent> <Leader>l <c-w>l
nnoremap <silent> <Leader>h <c-w>h

" File Explorer (NvimTree)
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <Leader>e :<C-u>NvimTreeToggle<Cr>

" Tabs (barbar)
nnoremap <silent> <Leader><tab> <Cmd>BufferPick<CR>
nnoremap <silent> <Leader>d    <Cmd>BufferPrev<CR>
nnoremap <silent> <Leader>f    <Cmd>BufferNext<CR>
nnoremap <silent> <Leader>c    <Cmd>BufferClose<CR>

" Fuzzy search
"nnoremap <silent> <Leader>pf    <Cmd>Telescope find_files<CR>
"nnoremap <leader>pg <cmd>Telescope live_grep<cr>

" Search and replace
nnoremap <leader>S <cmd>lua require('spectre').open()<CR>
