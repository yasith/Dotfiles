" not compatible with vi
set nocompatible

" start pathogen with the default dir ~/.vim/bundle
call pathogen#infect()

" enable filetype plugin and indentation
filetype plugin indent on

" enable syntax highlighting
syntax on

" enable auto indentation, set tabstop,shift-width, expand tabs into spaces
set ai ts=2 sw=2 expandtab

" set line numbers
set nu

" to make powerline visible
set laststatus=2

" powerline needs unicode chars
set encoding=utf-8

" triangular stuff for powerline
let g:Powerline_symbols = 'fancy'

" for solarized color scheme
set t_Co=16
set background=dark
colorscheme solarized

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" highlight matches, incremental searches, case insensitive unless mixed
set hlsearch incsearch ignorecase smartcase

" set leader to ,
let mapleader=","

" toggle for NERDTree
nmap <leader>n <ESC>:NERDTreeToggle<CR>

" mappings for ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" files to ignore for ctrlp
set wildignore+=*.so,*.swp,*.zip,*.pyc

" Set cryptmethod to blowfish
setlocal cm=blowfish

