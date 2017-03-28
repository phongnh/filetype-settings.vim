if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

nnoremap <silent> <buffer> g=
            \ :execute 'silent! %' . printf("!env XMLLINT_INDENT='%s' xmllint --format --recover - 2>/dev/null", repeat(' ', exists('*shiftwidth') ? shiftwidth() : &shiftwidth))<CR>
