setlocal tabstop=2 shiftwidth=2

if exists('&omnifunc') && &omnifunc ==# 'syntaxcomplete#Complete'
    setlocal omnifunc=
endif

let b:surround_{char2nr('#')} = "#{\r}"
