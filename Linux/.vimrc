set nocompatible
set lazyredraw tgc
set autoread autowrite
set nobackup nowb noswapfile hidden
set tabstop=4 softtabstop=4 expandtab breakindent
set number laststatus=2 wildmenu
set incsearch ignorecase smartcase hlsearch backspace=indent,eol,start
set encoding=utf-8 fileencoding=utf-8 ff=unix

" For allowing TrueColor in Vim
set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum

autocmd! FileType text set nonumber

" Plugins
call plug#begin('~/.vim/vplug')
    " Colors
    Plug 'plan9-for-vimspace/acme-colors'

    " UI Plugins
    "Plug 'itchyny/lightline.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    "Plug 'mgee/lightline-bufferline'
    Plug 'ap/vim-buftabline'
    "Plug 'cocopon/lightline-hybrid.vim'

    " Tools
    Plug 'vimwiki/vimwiki'
    "Plug 'reedes/vim-pencil'
    Plug 'thaerkh/vim-workspace'
    "Plug 'rhysd/committia.vim'
    "Plug 'junegunn/gv.vim'
    Plug 'lambdalisue/gina.vim'

call plug#end()

let g:mapleader=" "

"Insert mode Remappings
imap jj <ESC>

" Normal mode remapping
nnoremap <leader>s :w!<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>x :qa!<cr>
nnoremap <leader>d :bd %<cr>
nnoremap <leader>l :ls<CR>:b<space>
nnoremap <leader>g :Goyo 100x95%<CR>
nnoremap <leader>t :ToggleWorkspace<CR>
nnoremap <leader>- :split<space>
nnoremap <leader>\ :vsplit<space>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nmap <silent> <BS> :noh<CR>

" Plugin Configuration
autocmd! User GoyoEnter Limelight 0.40
autocmd! User GoyoLeave Limelight!

" Vim-Pencil
"augroup pencil
"        autocmd! FileType text call pencil#init({'wrap':'hard', 'autoformat': 0})
"augroup END

" Custom Config
"let g:lightline={'colorscheme': 'hybrid'}
"let g:lightline_hybrid_style='plain'
"let g:buftabline_show=1
"let g:buftabline_numbers=2
"let g:buftabline_indicators=1

colorscheme acme
