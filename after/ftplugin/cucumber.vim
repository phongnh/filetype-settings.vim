function! s:BarAlign() abort
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfunction

function! s:ToggleBarAlign() abort
    if mapcheck('<Bar>', 'i') == ''
        inoremap <silent> <buffer> <Bar> <Bar><Esc>:call <SID>BarAlign()<CR>a
        echo "Enabled Bar Align!"
    else
        iunmap <buffer> <Bar>
        echo "Disabled Bar Align!"
    endif
endfunction

inoremap <silent> <buffer> <Bar> <Bar><Esc>:call <SID>BarAlign()<CR>a
nnoremap <silent> <buffer> co<Bar> :call <SID>ToggleBarAlign()<CR>
