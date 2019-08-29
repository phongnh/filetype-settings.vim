setlocal conceallevel=0

if executable('jq')
    command! -buffer -bar -nargs=? FormatJSON :%!jq -e -M <args> .
elseif executable('python3')
    command! -buffer -bar -nargs=? FormatJSON :%!python3 -m json.tool <args>
elseif executable('python')
    command! -buffer -bar -nargs=? FormatJSON :%!python -m json.tool <args>
endif
