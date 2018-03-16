setlocal tabstop=2 shiftwidth=2

let b:surround_{char2nr('#')} = "#{\r}"
let b:surround_{char2nr('-')} = "<% \r %>"
let b:surround_{char2nr('=')} = "<%= \r %>"

if get(g:, 'enable_ruby_converters')
    call filetype_settings#setup_ruby_converters()
endif
