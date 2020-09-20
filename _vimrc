set term=xterm-256color
set number
set title
set ambiwidth=double
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set nrformats-=octal
set hidden
set history=50
set virtualedit=block
set whichwrap=b,s,[,],<,>
set backspace=indent,eol,start
set wildmenu
:syntax on

set nocompatible
filetype off
filetype plugin on

""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'Shougo/unite.vim' " ファイルオープンを便利にする
Plug 'Shougo/neomru.vim' " 最近使ったファイルを表示できるようにする
Plug 'tomtom/tcomment_vim' " コメントON/OFFを手軽に実行
Plug 'nathanaelkane/vim-indent-guides' " インデントに色を付けて見やすくする
Plug 'bronson/vim-trailing-whitespace' " 行末の半角スペースを可視化
Plug 'tpope/vim-endwise'

" @see: https://techracho.bpsinc.jp/jhonda/2019_12_24/85173
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Unit.vimの設定
""""""""""""""""""""""""""""""
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>


""""""""""""""""""""""""""""""
" fzf.vimの設定
" @see: https://techracho.bpsinc.jp/jhonda/2019_12_24/85173
""""""""""""""""""""""""""""""
if executable('rg')
    command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --line-number --no-heading '.shellescape(<q-args>), 0,
        \   fzf#vim#with_preview({'options': '--exact --reverse --delimiter : --nth 3..'}, 'up:50%:wrap'))
endif

"""""""""""""""""""""""""""""

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

""""""""""""""""""""""""""""""
" 自動的に閉じ括弧を入力
""""""""""""""""""""""""""""""
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>
""""""""""""""""""""""""""""""
