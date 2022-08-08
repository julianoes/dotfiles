call plug#begin(stdpath('data') . 'plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'sjl/gundo.vim'
Plug 'lifepillar/vim-solarized8'

Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'robert-oleynik/clangd-nvim'
"Plug 'neoclide/coc.nvim'

" For telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

call plug#end()

" Map leader to ,
let mapleader = ","

" Open vimrc
nmap <leader>v :e $MYVIMRC<CR>

if has('termguicolors')
  set termguicolors
  set background=light
  colorscheme solarized8
endif

" don't fold
set nofoldenable

" show line number
set nu

" use default of 4 spaces, no tab
set tabstop=4
set shiftwidth=4
set expandtab

" Find files using Telescope command-line sugar.
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <c-g> <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>
"nnoremap <leader>fl <cmd>Telescope git_files<cr>

" Custom map for moving around between windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" coc.nvim
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" File specific formatting
autocmd BufRead,BufNewFile,BufEnter *.py setlocal ts=4 sw=4 expandtab colorcolumn=80
autocmd BufRead,BufNewFile,BufEnter *.yaml setlocal ts=2 sw=2 expandtab colorcolumn=80
autocmd BufRead,BufNewFile,BufEnter *.yml setlocal ts=2 sw=2 expandtab colorcolumn=80
