setlocal conceallevel=0

if executable('jq')
    command! -buffer -nargs=? FormatJSON :%!jq <args> .
elseif executable('python3')
    command! -buffer -nargs=? FormatJSON :%!python3 -m json.tool <args>
elseif executable('python')
    command! -buffer -nargs=? FormatJSON :%!python -m json.tool <args>
endif
