" ==========================================================
" DTree - a vim plugin to show file tree
" Git Repository: https://github.com/StarAndRabbit/DTree.git
" Version: 0.3 Beta
" Author: Dai Bingzhi <daibingzhi@foxmail.com>
" Last Change: 2017.04.19
" ==========================================================

" make sure the module loaded once
if exists('g:dtree_loaded')
    finish
else
    let g:dtree_loaded = 1
endif

command! -nargs=0 DTreeToggle call s:ToggleDTree()

let s:filetreeap = []   " file tree absolute path
let s:filetree = []     " file tree ready for display
let s:openeddir = {}    " opened directory and its contents

function! s:ResetAll()
    let s:filetreeap = []
    let s:filetree = []
    let s:openeddir = {}
endfunction

" get file list in parament directory
function! s:GetFileList(absolutepath)
    let l:ftlist = split(system('/bin/ls ' . a:absolutepath), '\n')
    return l:ftlist
endfunction

" helper function to insert dstlist into srclist
function! s:Insert(srclist, dstlist, index)
    let l:tmpleft = a:srclist[:a:index]
    let l:tmpright = a:srclist[a:index + 1:]
    return l:tmpleft + a:dstlist + l:tmpright
endfunction

" Function: IsDirClosed
" if closed, return 1, else return 0
function! s:IsDirClosed(index)
    if match(s:filetree[a:index], "▷") != -1
        return 1
    else
        return 0
    endif
endfunction

" Function: IsDirOpened
" if opened, return 1, else return 0
function! s:IsDirOpened(index)
    if match(s:filetree[a:index], "▽") != -1
        return 1
    else
        return 0
    endif
endfunction

" get current work directory's file tree
function! s:GetRootFileList()
    call s:ResetAll()
    let l:cwd = getcwd()
    let s:filetree = split(system('/bin/ls'), '\n')
    for l:file in s:filetree
        call add(s:filetreeap, l:cwd . "/" . l:file)
    endfor
    let s:filetree = dtreeui#DivideFileList(s:filetree, s:filetreeap, 0)
    call dtreeui#RefreshUI(s:filetree)
endfunction

" open directory to show its contents and refresh UI
function! s:OpenDir(index)
    let l:contentfile = s:GetFileList(s:filetreeap[a:index])
    let l:contentfileabpath = []
    for l:file in l:contentfile
        call add(l:contentfileabpath, s:filetreeap[a:index] . "/" . l:file)
    endfor
    let l:contentfile = dtreeui#DivideFileList(l:contentfile, l:contentfileabpath, dtreeui#GetDepth(s:filetree[a:index]) + 1)
    let s:filetree[a:index] = dtreeui#RefreshOpenedDir(s:filetree[a:index])
    let s:filetree = s:Insert(s:filetree, l:contentfile, a:index)
    let s:filetreeap = s:Insert(s:filetreeap, l:contentfileabpath, a:index)
    let s:openeddir[s:filetreeap[a:index]] = l:contentfileabpath
    call dtreeui#RefreshUI(s:filetree)
endfunction

" recursive close directory and refresh UI
function! s:CloseDir(index)
    let l:count = 1
    for l:file in s:openeddir[s:filetreeap[a:index]]
        if isdirectory(l:file)
            if s:IsDirOpened(a:index + l:count)
                call s:CloseDir(a:index + l:count)
            endif
        endif
        let l:count += 1
    endfor
    if len(s:openeddir[s:filetreeap[a:index]]) != 0     " directory is not empty
        call remove(s:filetreeap, a:index + 1, a:index + len(s:openeddir[s:filetreeap[a:index]]))
        call remove(s:filetree, a:index + 1, a:index + len(s:openeddir[s:filetreeap[a:index]]))
    endif
    call remove(s:openeddir, s:filetreeap[a:index])
    let s:filetree[a:index] = dtreeui#RefreshClosedDir(s:filetree[a:index])
    call dtreeui#RefreshUI(s:filetree)
endfunction

" open or close directory
function! s:ToggleDir(index)
    if s:IsDirClosed(a:index)
        call s:OpenDir(a:index)
    else
        call s:CloseDir(a:index)
    endif
endfunction

" open normal file
function! s:OpenFile(index)
    if winnr('$') == 1
        execute('vertical rightbelow sp ' . s:filetreeap[a:index])
        let l:newwinid = win_getid(winnr())
        call win_gotoid(bufwinid('__DTree__'))
        execute('vertical resize 30')
        call win_gotoid(l:newwinid)
    else
        call win_gotoid(win_getid(winnr('#')))
        execute('e ' . s:filetreeap[a:index])
    endif
endfunction

" open file tree window
function! s:OpenFileTree()
    execute('vertical topleft sp __DTree__')
    execute('vertical resize 30')
    let l:lastwinid = win_getid(winnr('#'))
    call s:GetRootFileList()
    set filetype=dtree
    call win_gotoid(l:lastwinid)
endfunction

" close file tree window
function! s:CloseFileTree()
    let l:lastwinid = win_getid(winnr())
    call win_gotoid(bufwinid('__DTree__'))
    execute('q!')
    call win_gotoid(l:lastwinid)
endfunction

function! ToggleFileOrDir(index)
    if isdirectory(s:filetreeap[a:index])
        call s:ToggleDir(a:index)
    else
        call s:OpenFile(a:index)
    endif
endfunction

function! s:ToggleDTree()
    if bufwinnr('__DTree__') == -1
        call s:OpenFileTree()
    else
        call s:CloseFileTree()
    endif
endfunction
