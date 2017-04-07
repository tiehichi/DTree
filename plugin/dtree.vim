" ==========================================================
" DTree - a vim plugin to show file tree
" Git Repository: https://github.com/StarAndRabbit/DTree.git
" Version: 0.1 Alpha
" Author: Dai Bingzhi <daibingzhi@foxmail.com>
" Last Change: 2017.04.07
" ==========================================================

" make sure the module loaded once
if exists('g:dtree_loaded')
    finish
else
    let g:dtree_loaded = 1
endif

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
function! GetRootFileList()
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
function! OpenDir(index)
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
function! CloseDir(index)
    let l:count = 1
    for l:file in s:openeddir[s:filetreeap[a:index]]
        if isdirectory(l:file)
            if s:IsDirOpened(a:index + l:count)
                call CloseDir(a:index + l:count)
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
