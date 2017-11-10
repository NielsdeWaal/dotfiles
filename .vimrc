function! NumberToggle()
	if(&relativenumber == 1)
		set number
	else
		set relativenumber
	endif
endfunc

set showmatch
set nocompatible
set showcmd
set confirm

"Disable arrow key's
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

"Map Ctlr-l to append ; at the end of the line
nmap <c-l> A;<ESC>

"Map ESC to jj
inoremap jj <ESC>

"Map Ctlr-n to select line number mode
nnoremap <C-n> :call NumberToggle()<cr>

"Copy to global vim buffer
vmap <C-c> :w! ~/.vimbuffer<CR>
nmap <C-c> :.w! ~/.vimbuffer<CR>
"Paste from global vim buffer
map <C-p> :r ~/.vimbuffer<CR>

"Set tab to 4 spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

"Set scroll off to 5 rows
set scrolloff=5

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'rust-lang/rust.vim'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'clausreinke/typescript-tools'
Plugin 'pangloss/vim-javascript'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'scrooloose/nerdTree'
Plugin 'lervag/vimtex'
Plugin 'tpope/vim-fugitive'
Plugin 'DoxygenToolkit.vim'
Plugin 'rhysd/vim-clang-format'

call vundle#end()
filetype plugin indent on

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Color Scheme
syntax enable
set background=dark
"colorscheme solarized

"Syntax for doxygen
"syntax on
let g:load_doxygen_syntax=1
let g:DoxygenToolkit_briefTag_pre="@brief "
let g:DoxygenToolkit_paramTag_pre="@param "
let g:DoxygenToolkit_returnTag="@return "
let g:DoxygenToolkit_authorName="Niels de Waal"

"Clang options
let g:clang_format#code_style="llvm"
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
