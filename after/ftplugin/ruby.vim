setlocal tabstop=2 shiftwidth=2

if exists('&omnifunc') && &omnifunc ==# 'syntaxcomplete#Complete'
    setlocal omnifunc=
endif

let b:surround_{char2nr('#')} = "#{\r}"

if get(g:, 'enable_ruby_converters')
    call filetype_settings#setup_ruby_converters()
endif
