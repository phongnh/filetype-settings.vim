if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal winheight=15
setlocal nobuflisted

nnoremap <silent> <buffer> q :close<CR>
