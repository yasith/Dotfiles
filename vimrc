" not compatible with vi
set nocompatible

" turn off filetype for Vundle to work
filetype off

" Make vundle work
set rtp+=~/dotfiles/vim/bundle/vundle
call vundle#rc()

" Repos from github - used by vundle
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/supertab'
Bundle "elzr/vim-json"
Bundle "exu/pgsql.vim"
Bundle 'garbas/vim-snipmate'
Bundle 'kien/ctrlp.vim'
Bundle 'kevinw/pyflakes-vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'majutsushi/tagbar'
Bundle 'Lokaltog/vim-powerline'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-vividchalk'
Bundle 'tpope/vim-surround'
Bundle 'tomtom/tlib_vim'

" Update bundles with :BundleInstall

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
"set t_Co=16
set background=dark
"colorscheme vividchalk

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

" VIM doesn't detect these extensions
" .S files as assembly files
au BufNewFile,BufRead *.S set ft=nasm
" .gradle files as groovy files (for syntax)
au BufNewFile,BufRead *.gradle set ft=groovy
" .json files need syntax highlighting too!
au BufNewFile,BufRead *.json set ft=json
" .sql files are postgres files for me
au BufNewFile,BufRead *.sql set ft=pgsql

