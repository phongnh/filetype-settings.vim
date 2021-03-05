setlocal keywordprg=:help
setlocal foldmethod=marker foldmarker={,}
setlocal commentstring=\"\ %s

if !hasmapto('<Leader>V')
    nnoremap <silent> <buffer> <Leader>V :update<CR>:source %<CR>:echo 'Sourced ' . expand('%') . '!'<CR>
endif
