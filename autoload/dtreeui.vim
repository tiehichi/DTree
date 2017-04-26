" =======================================================
" dtreeui - some functions to refresh ui for plugin DTree
" Author: Dai Bingzhi <daibingzhi@foxmail.com>
" Last Change: 2017.04.16
" =======================================================

" Function: DivideFileList
" divide file list to normal file and directory
" Directory: '+' + dirname
" Normal File: ' ' + filename
function! dtreeui#DivideFileList(ftlist, abfilepath, depth)
    let l:ftlist = deepcopy(a:ftlist)

    let l:index = 0
    for l:file in a:abfilepath
        if isdirectory(l:file)
            let l:ftlist[l:index] = '+' . l:ftlist[l:index] . '/'
        else
            let l:ftlist[l:index] = ' ' . l:ftlist[l:index]
        endif
        
        let l:dep = 0
        while l:dep < a:depth
            let l:ftlist[l:index] = "\t" . l:ftlist[l:index]
            let l:dep += 1
        endwhile
        
        let l:index += 1
    endfor

    return l:ftlist
endfunction

" Function: RefreshOpenedDir
" change the displayed directory's state, from '+' to '-'
function! dtreeui#RefreshOpenedDir(dirpath)
    return substitute(a:dirpath, "+", "-", "e")
endfunction

" Function: RefreshClosedDir
" change the displayed directory's state, from '-' to '+'
function! dtreeui#RefreshClosedDir(dirpath)
    return substitute(a:dirpath, "-", "+", "e")
endfunction

" Function: RefreshUI
" refresh displayed file tree
function! dtreeui#RefreshUI(ftlist)
    let l:saveview = winsaveview()
    setlocal modifiable
    normal gg
    normal dG
    call append(0, a:ftlist)
    normal dd       
    normal gg
    setlocal nomodifiable
    call winrestview(l:saveview)
endfunction

" Function: GetDepth
" get a file's depth from work directory
function! dtreeui#GetDepth(dirabpath)
    let l:count = 0
    let l:depth = 0
    while l:count < len(a:dirabpath)
        if a:dirabpath[l:count] == "\t"
            let l:depth += 1
        else
            break
        endif
        let l:count += 1
    endwhile
    return l:depth
endfunction
