setlocal tabstop=2 shiftwidth=2

let b:surround_{char2nr('#')} = "#{\r}"
let b:surround_{char2nr('-')} = "<% \r %>"
let b:surround_{char2nr('=')} = "<%= \r %>"
