" Held together by AI and ducktape (really an insult to ducktape) 

set runtimepath+=$HOME/vimfiles

call plug#begin('%USERPROFILE%\vimfiles\autoload\plug.vim')
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
call plug#end()

let g:loaded_matchparen=1 " disable highlighting

" are visual bells designed to give you epilepsy? wtf?
set vb t_vb=
set number

" https://vi.stackexchange.com/questions/13080/setting-tab-to-2-spaces
set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set autoindent smartindent
syntax enable
filetype plugin indent on

let &t_SI = "\e[5 q" " insert mode: Blinking bar
let &t_SR = "\e[3 q" " replace mode: Blinking underline
let &t_EI = "\e[1 q" " normal mode: Blinking block

let g:netrw_banner = 0        " hide help banner 
let g:netrw_liststyle = 3     " tree view
let g:netrw_winsize = 20      " 20% width
let g:netrw_browse_split = 4  " open files in previous window 
let g:netrw_altv = 1          " split to the right
let g:netrw_list_hide = '\.swp$'  " hide .swp files

set cmdheight=1

" disable jumping around when typing closing paren
set noshowmatch

" keyboard shortcuts
nnoremap <Leader>1 :1wincmd w<Cr>
nnoremap <Leader>2 :2wincmd w<Cr>
nnoremap <Leader>3 :3wincmd w<Cr>
nnoremap <Leader>4 :4wincmd w<Cr>

autocmd TerminalOpen * setlocal nonumber norelativenumber signcolumn=no bufhidden=hide 
autocmd QuitPre * silent! bufdo if &buftype == 'terminal' | bwipeout! | endif

function! ToggleTerminal()
    let l:term_win = bufwinnr('!sh')

    " If window is visible, hide
    if l:term_win != -1
        execute l:term_win . 'hide'
        if exists('g:last_code_window')
          call win_gotoid(g:last_code_window)
        endif
    else
        let g:last_code_window = win_getid()
        
        " if not visible, check if the buffer exists in the background
        let l:term_buf = bufnr('!sh')
        if l:term_buf != -1
            " re-open the existing background buffer
            execute 'botright sbuf ' . l:term_buf
            execute 'resize 7'
        else
            " create a brand new terminal
            botright terminal ++rows=7
        endif
    endif
endfunction

" toggle terminal keybindings
nnoremap <silent> <C-t> :call ToggleTerminal()<CR>
tnoremap <silent> <C-t> <C-W>:call ToggleTerminal()<CR>

" Esc enters normal mode in terminal
tnoremap <Esc> <C-\><C-n>

function! NetrwTouch()
  let l:filename = input('Please give file name: ')
  if l:filename != ''
    call system('touch ' . shellescape(b:netrw_curdir . '/' . l:filename))
    execute 'normal r'
  endif
endfunction

" touch a new file. easy.
autocmd FileType netrw nnoremap <buffer> t :call NetrwTouch()<CR>

" force quit vim, inspired by Ctrl-Q-Q
nnoremap <Leader>qq :bufdo bwipeout!<CR>:qa!<CR>
