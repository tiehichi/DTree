function! GetFileList(path)
    let l:ftlist = split(system('/bin/ls ' . a:path), '\n')
    return l:ftlist
endfunction

function! DivideFileList(ftlist, depth)
    let l:ftlist = deepcopy(a:ftlist)

    let l:index = 0
    for l:file in l:ftlist
        if isdirectory(file)
            let l:ftlist[l:index] = '▷' . l:file . '/'
        else
            let l:ftlist[l:index] = ' ' . l:file
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

function! Insert(srclist, dstlist, index)
    let l:tmpleft = a:srclist[:a:index]
    let l:tmpright = a:srclist[a:index + 1:]
    
    return l:tmpleft + a:dstlist + l:tmpright
endfunction

function! RefreshOpenedDir(dirpath)
    return substitute(a:dirpath, "▷", "▽", "e")
endfunction

function! RefreshClosedDir(dirpath)
    return substitute(a:dirpath, "▽", "▷", "e")
endfunction

function! RefreshUI(ftlist)
    set modifiable
    normal gg
    normal dG
    call append(0, a:ftlist)
    normal dd       "delete last blank line
    normal gg
    set nomodifiable
endfunction

function! GetDepth(dirpath)
    let l:count = 0
    let l:depth = 0
    while l:count < len(a:dirpath)
        if a:dirpath[l:count] == "\t"
            let l:depth += 1
        else
            break
        endif
        let l:count += 1
    endwhile
    return l:depth
endfunction
