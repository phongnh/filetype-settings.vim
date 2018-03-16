if get(g:, 'enable_xmllint_indent', 0)
    nnoremap <silent> <buffer> g=
                \ :execute 'silent! %' . printf("!env XMLLINT_INDENT='%s' xmllint --format --recover - 2>/dev/null", repeat(' ', exists('*shiftwidth') ? shiftwidth() : &shiftwidth))<CR>
endif
