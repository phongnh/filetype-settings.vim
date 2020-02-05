setlocal keywordprg=:help
setlocal foldmethod=marker foldmarker={,}

if !hasmapto('<Leader>V')
    nnoremap <silent> <buffer> <Leader>V :source %<CR>:echo 'Sourced ' . expand('%') . '!'<CR>
endif
