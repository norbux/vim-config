" Vim with all enhancements
"source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" Font, line numbers, tabs (and color scheme for gVim)
"--------------------------------------------------------------------------------
syntax on
set guifont=Source_Code_Pro:h11:cANSI:qDRAFT
set number
"set numberwidth=4
set tabstop=4
set shiftwidth=4
"set textwidth=4
"set expandtab
"color ron
color desert
set autochdir

" Zoom text in and out
"--------------------------------------------------------------------------------
function! AdjustFontSize(amount)
    if !has("gui_running")
        echoerr "You need to run a GUI version of Vim to use this function."
    endif

    let l:minfontsize = 6
    let l:maxfontsize = 16

    " Windows and macOS &guifont: Hack\ NF:h10:cANSI
    " Linux &guifont: Hack\ Nerd\ Font\ Mono\ Regular\ 10
    
    " A multiplatform pattern for Linux, Windows, and macOS:
    " \v            very magical.
    " (^\D{-1,})    Capture group 1 = [Anchored at the start of the string, match any character that is not [0-9] 1 or more times non-greedy].
    " (\d+)         Capture group 2 = [match [0-9] 1 or more times].
    " (\D*$)        Capture group 3 = [match any character that is not [0-9] 0 or more times to the end of the string].
    let l:pattern = '\v(^\D{-1,})(\d+)(\D*$)'

    " Break the font string into submatches.
    let l:matches = matchlist(&guifont, l:pattern)
    let l:start = l:matches[1]
    let l:size = l:matches[2]
    let l:end = l:matches[3]

    let newsize = l:size + a:amount
    if (newsize >= l:minfontsize) && (newsize <= l:maxfontsize)
        let newfont = l:start . newsize . l:end
        let &guifont = newfont
    endif
endfunction

nnoremap <silent> <F11> :call AdjustFontSize(-1)<CR>
inoremap <silent> <F11> <Esc>:call AdjustFontSize(-1)<CR>
vnoremap <silent> <F11> <Esc>:call AdjustFontSize(-1)<CR>
cnoremap <silent> <F11> <Esc>:call AdjustFontSize(-1)<CR>
onoremap <silent> <F11> <Esc>:call AdjustFontSize(-1)<CR>

nnoremap <silent> <F12> :call AdjustFontSize(1)<CR>
inoremap <silent> <F12> <Esc>:call AdjustFontSize(1)<CR>
vnoremap <silent> <F12> <Esc>:call AdjustFontSize(1)<CR>
cnoremap <silent> <F12> <Esc>:call AdjustFontSize(1)<CR>
onoremap <silent> <F12> <Esc>:call AdjustFontSize(1)<CR>

" Hold Control + scroll mouse-wheel to zoom text.
" NOTE: This event only works for Linux and macOS. SEE: :h scroll-mouse-wheel
"map <silent> <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
"map <silent> <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>

map <silent> <C-LeftMouse> :call AdjustFontSize(-1)<CR>
map <silent> <C-RightMouse> :call AdjustFontSize(1)<CR>

map <silent> <C-Left> :call AdjustFontSize(-1)<CR>
map <silent> <C-Right> :call AdjustFontSize(1)<CR>


" netrw configuration
"--------------------------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END
