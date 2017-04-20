if exists('g:loaded_filetype_settings')
    finish
endif

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

command! -nargs=0 ToggleBarAlign call <SID>ToggleBarAlign()

nnoremap <silent> coa :ToggleBarAlign<CR>

augroup FiletypeSettingsPlugin
    autocmd!

    " Vim
    autocmd FileType vim setlocal keywordprg=:help

    " Help
    autocmd FileType help setlocal keywordprg=:help noexpandtab

    " Quickfix
    autocmd FileType qf setlocal winheight=15 nobuflisted

    " tigrc
    autocmd BufNewFile,BufRead {,*}.tigrc setfiletype tigrc
    autocmd FileType tigrc setlocal noexpandtab tabstop=8 commentstring=#\ %s

    " Ruby-related
    autocmd FileType ruby,eruby,yaml,haml,markdown,less,sass,scss,coffee,cucumber,html.handlebars setlocal tabstop=2 shiftwidth=2

    autocmd FileType ruby,yaml,eruby,coffee,haml let b:surround_35 = "#{\r}"
    autocmd FileType eruby let b:surround_45 = "<% \r %>"
    autocmd FileType eruby let b:surround_61 = "<%= \r %>"

    " CSS / Less
    autocmd FileType css,less setlocal iskeyword+=-

    " JSON
    autocmd FileType json setlocal conceallevel=0

    " SQL
    autocmd FileType sql setlocal omnifunc= commentstring=--\ %s

    " XML
    if executable('xmllint')
        autocmd FileType xml nnoremap <silent> <buffer> g=
                    \ :execute 'silent! %' . printf("!env XMLLINT_INDENT='%s' xmllint --format --recover - 2>/dev/null", repeat(' ', exists('*shiftwidth') ? shiftwidth() : &shiftwidth))<CR>
    endif

    " Fish
    autocmd FileType fish setlocal omnifunc=

    " clang
    autocmd FileType c,cpp setlocal commentstring=//\ %s

    " Go
    autocmd FileType go,godoc,gedoc setlocal noexpandtab
    autocmd FileType godoc,gedoc    setlocal tabstop=8

    " Git
    autocmd FileType gitcommit setlocal textwidth=72 winheight=20 spell
    autocmd FileType git,gitconfig setlocal tabstop=8

    " q to close
    autocmd FileType help,qf,godoc,gedoc nnoremap <silent> <buffer> q :close<CR>

    " Folding
    autocmd FileType vim setlocal foldmethod=marker foldmarker={{{,}}}
    autocmd FileType nginx,puppet,c,javascript,go,less,css setlocal foldmethod=marker foldmarker={,}

    " nginx
    autocmd FileType nginx setlocal noexpandtab commentstring=#\ %s
    
    " cucumber
    autocmd FileType cucumber inoremap <silent> <buffer> <Bar> <Bar><Esc>:call <SID>BarAlign()<CR>a
augroup END

let g:loaded_filetype_settings = 1
