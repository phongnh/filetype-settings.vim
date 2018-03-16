setlocal tabstop=2 shiftwidth=2

inoremap <silent> <buffer> <Bar> <Bar><Esc>:call filetype_settings#bar_align()<CR>a
