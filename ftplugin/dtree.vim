set nowrap
set noreadonly
set buftype=nofile
set bufhidden=delete
set nonumber
nnoremap <silent> <enter> :call ToggleFileOrDir(line('.') - 1)<enter>
