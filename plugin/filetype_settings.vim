if get(g:, 'loaded_filetype_settings', 0)
    finish
endif

let g:enable_ruby_converters  = get(g:, 'enable_ruby_converters', 1)
let g:enable_rspec_converters = get(g:, 'enable_ruby_converters', 1)
let g:enable_xmllint_indent   = get(g:, 'enable_xmllint_indent', executable('xmllint'))

function! s:ToggleBarAlign() abort
    if mapcheck('<Bar>', 'i') == ''
        inoremap <silent> <buffer> <Bar> <Bar><Esc>:call filetype_settings#bar_align()<CR>a
        echo "Enabled Bar Align!"
    else
        iunmap <buffer> <Bar>
        echo "Disabled Bar Align!"
    endif
endfunction

if exists(':Tabularize') == 2
    command! -nargs=0 ToggleBarAlign call <SID>ToggleBarAlign()
    nnoremap <silent> yo<Bar> :ToggleBarAlign<CR>
endif

let g:loaded_filetype_settings = 1
