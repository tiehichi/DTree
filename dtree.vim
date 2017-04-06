let s:filetreeap = []   " file tree absolute path
let s:filetree = []     " file tree ready for display

" get current work directory's file tree
function! GetRootFileList()
    let l:cwd = getcwd()
    let s:filetree = split(system('/bin/ls'), '\n')
    for l:file in s:filetree
        call add(s:filetreeap, l:cwd . "/" . l:file)
    endfor
endfunction

" get file list in parament directory
function! GetFileList(absolutepath)
    let l:ftlist = split(system('/bin/ls ' . a:absolutepath), '\n')
    return l:ftlist
endfunction

" helper function to insert dstlist into srclist
function! Insert(srclist, dstlist, index)
    let l:tmpleft = a:srclist[:a:index]
    let l:tmpright = a:srclist[a:index + 1:]
    return l:tmpleft + a:dstlist + l:tmpright
endfunction
