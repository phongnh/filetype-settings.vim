if executable('xmllint')
    command! -buffer -bar FormatXML
                \ execute printf(
                \   'silent! :%%!env XMLLINT_INDENT="%s" xmllint --format --recover - 2>/dev/null',
                \   repeat(' ', exists('*shiftwidth') ? shiftwidth() : &shiftwidth)
                \ )
endif
