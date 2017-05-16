setlocal nowrap
setlocal noreadonly
setlocal buftype=nofile
setlocal bufhidden=delete
setlocal nonumber
setlocal tabstop=4
nnoremap <buffer> <silent> <enter> :call ToggleFileOrDir(line('.') - 1)<enter>
