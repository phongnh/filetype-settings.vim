if executable('xmllint')
    command! -buffer -bar FormatXML
                \ :execute printf("silent! %%!env XMLLINT_INDENT='%s' xmllint --format --recover - 2>/dev/null", repeat(' ', exists('*shiftwidth') ? shiftwidth() : &shiftwidth))

    if get(g:, 'enable_xmllint_indent', 0)
        nnoremap <silent> <buffer> g= :FormatXML<CR>
    endif
endif
