" Two-way diff each side of a file with Git conflict markers
" Maintainer: Seth House <seth@eseth.com>
" License: MIT

if exists("g:loaded_diffconflicts")
    finish
endif
let g:loaded_diffconflicts = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:hasConflicts()
    try
        silent execute "%s/^<<<<<<< //gn"
        return 1
    catch /Pattern not found/
        return 0
    endtry
endfunction

function! s:diffconfl()
    let l:origBuf = bufnr("%")

    " Set up the right-hand side.
    rightb vsplit
    enew
    silent execute "read #". l:origBuf
    1delete
    silent execute "file RCONFL"
    silent execute "g/^<<<<<<< /,/^=======\\r\\?$/d"
    silent execute "g/^>>>>>>> /d"
    setlocal nomodifiable readonly buftype=nofile bufhidden=delete nobuflisted
    diffthis

    " Set up the left-hand side.
    wincmd p
    silent execute "g/^=======\\r\\?$/,/^>>>>>>> /d"
    silent execute "g/^<<<<<<< /d"
    diffthis
endfunction

function! s:showHistory()
    " Create the tab and windows.
    tabnew
    vsplit
    vsplit
    wincmd h
    wincmd h

    " Populate each window.
    buffer LOCAL
    setlocal nomodifiable readonly
    diffthis

    wincmd l
    buffer BASE
    setlocal nomodifiable readonly
    diffthis

    wincmd l
    buffer REMOTE
    setlocal nomodifiable readonly
    diffthis

    " Put cursor in back in BASE.
    wincmd h
endfunction

function! s:checkThenShowHistory()
    let l:xs =
        \ filter(
        \   map(
        \     filter(
        \       range(1, bufnr('$')),
        \       'bufexists(v:val)'
        \     ),
        \     'bufname(v:val)'
        \   ),
        \   'v:val =~# "BASE" || v:val =~# "LOCAL" || v:val =~# "REMOTE"'
        \ )

    if (len(l:xs) < 3)
        echohl WarningMsg
            \ | echo "Missing one or more of BASE, LOCAL, REMOTE."
            \   ." Was Vim invoked by a Git mergetool?"
            \ | echohl None
        return 1
    else
        call s:showHistory()
        return 0
    endif
endfunction

function! s:checkThenDiff()
    if (s:hasConflicts())
        redraw
        echohl WarningMsg
            \ | echon "Resolve conflicts leftward then save. Use :cq to abort."
            \ | echohl None
        return s:diffconfl()
    else
        echohl WarningMsg | echo "No conflict markers found." | echohl None
    endif
endfunction

command! DiffConflicts call s:checkThenDiff()
command! DiffConflictsShowHistory call s:checkThenShowHistory()
command! DiffConflictsWithHistory call s:checkThenShowHistory()
    \ | 1tabn
    \ | call s:checkThenDiff()

let &cpo = s:save_cpo
unlet s:save_cpo
