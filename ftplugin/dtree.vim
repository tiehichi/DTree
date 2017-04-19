set nowrap
set noreadonly
set buftype=nofile
set bufhidden=delete
set nonumber
nnoremap <enter> :call ToggleFileOrDir(line('.') - 1)<enter>
