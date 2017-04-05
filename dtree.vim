function! GetFileList()
    let l:ftlist = split(system('/bin/ls'), '\n')
    return l:ftlist
endfunction

function! DivideFileList(ftlist)
    let l:ftlist = deepcopy(a:1)

    let l:index = 0
    for l:file in a:1
        if isdirectory(fnameescape(file))
            let l:ftlist[l:index] = '▷' . l:file
        else
            let l:ftlist[l:index] = ' ' . l:file
        endif
        let l:index += 1
    endfor

    return l:ftlist
endfunction
