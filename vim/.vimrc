set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-surround'
Plugin 'dense-analysis/ale'
" Plugin 'chriskempson/base16-vim'
" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'itchyny/lightline.vim'
" Plugin 'tomtom/tcomment_vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ycm-core/YouCompleteMe'
" Plugin 'z0mbix/vim-shfmt'
Plugin 'rust-lang/rust.vim'
Plugin 'python-mode/python-mode'
" Plugin 'lervag/vimtex'
" Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'othree/html5.vim'
Plugin 'mattn/emmet-vim'

" let g:Tex_DefaultTargetFormat = 'pdf'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

" :R to run open bash script
" command R !./%
" nnoremap <buffer> <F9> :exec '!./%' shellescape(@%, 1)<cr>


" let g:pymode_lint_write = 0       "turn off running pylint on file save
" let mapleader = ","
" nnoremap <leader>p :PymodeLint<cr>    "pressing ,p will run pylint on current buffer

" set list

syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set number
set autoindent
filetype indent on
set wildmode=longest,list,full
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set foldenable
set foldlevelstart=10
set foldnestmax=10
nnoremap <space> za
set foldmethod=indent
set background=dark

set shortmess=I


" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set tags=/home/ethan/programming/esp32/tags
cs add /home/ethan/programming/esp32/cscope.out


" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']
" Disable warnings about trailing whitespace for Python files.
"
" let g:indent_guides_enable_on_vim_startup = 1
