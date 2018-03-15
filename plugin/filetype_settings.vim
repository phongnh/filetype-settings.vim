if get(g:, 'loaded_filetype_settings', 0)
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

nnoremap <silent> =o<Bar> :ToggleBarAlign<CR>

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

    " haml
    autocmd BufNewFile,BufRead *.inky-haml setfiletype haml
    autocmd BufNewFile,BufRead *.hamlc setfiletype haml

    " Ruby-related
    autocmd FileType ruby,eruby,yaml,haml,markdown,less,sass,scss,coffee,cucumber,html.handlebars,hbs,handlebars
                \ setlocal tabstop=2 shiftwidth=2

    autocmd FileType html.handlebars,hbs,handlebars
                \ setlocal commentstring={{!--\ %s\ --}}    |
                \ let b:surround_{char2nr('{')} = "{{\r}}"  |
                \ let b:surround_{char2nr('}')} = "{{\r}}"  |
                \ let b:surround_{char2nr('#')} = "{{#\r}}"

    autocmd FileType ruby,yaml,eruby,coffee,haml let b:surround_{char2nr('#')} = "#{\r}"
    autocmd FileType eruby
                \ let b:surround_{char2nr('-')} = "<% \r %>"  |
                \ let b:surround_{char2nr('=')} = "<%= \r %>"

    " RSpec
    autocmd BufNewFile,BufRead *_spec.rb
                \ let b:surround_{char2nr('a')} = "allow(\r)"                  |
                \ let b:surround_{char2nr('A')} = "allow_any_instance_of(\r)"  |
                \ let b:surround_{char2nr('e')} = "expect(\r)"                 |
                \ let b:surround_{char2nr('E')} = "expect_any_instance_of(\r)" |
                \ let b:surround_{char2nr('c')} = "expect { \r }"

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
    autocmd FileType gitcommit setlocal textwidth=72 winheight=10 spell
    autocmd FileType git,gitconfig setlocal tabstop=8

    " q to close
    autocmd FileType help,qf,godoc,gedoc nnoremap <silent> <buffer> q :close<CR>

    " Folding
    autocmd FileType vim,nginx,puppet,c,javascript,go,less,css setlocal foldmethod=marker foldmarker={,}

    " nginx
    autocmd FileType nginx setlocal noexpandtab commentstring=#\ %s

    " cucumber
    autocmd FileType cucumber inoremap <silent> <buffer> <Bar> <Bar><Esc>:call <SID>BarAlign()<CR>a
augroup END

" Ruby Converters {
if get(g:, 'enable_ruby_converters', 1)
    function! s:SetupRubyConverters() abort
        " https://robots.thoughtbot.com/convert-ruby-1-8-to-1-9-hash-syntax
        command! -buffer -nargs=0 ConvertRubyHashSyntax %s/:\([^ :]*\)\(\s*\)=>\(\s*\)/\1: /egc

        " https://coderwall.com/p/kwno0w/vim-regex-to-change-hash-rockets-to-new-hash-syntax-in-ruby
        command! -buffer -nargs=0 ConvertRubyHashRockets %s/:\([^ =,'":]*\)\(\s*\)=>\(\s*\)/\1: /egc

        " http://blog.griffinsmith.me/post/2014/09/10/a-vim-oneliner-for-converting-ruby-hash-syntax/
        " command! -buffer -nargs=0 ChangeRubyHashSyntax %s/:\(\S\{-}\)\(\s\{-}\)=>/\1:\2/egc

        " Other
        " %s/\([^:]\):\([a-z0-9_]\+\)\s\+=>/\1\2:/gc


        " https://coderwall.com/p/sqopga/replace-double-quotes-with-single-quotes-in-vim
        " %s/\"\([^"]*\)\"/'\1'/gc

        " My pattern
        command! -buffer -nargs=0 ConvertRubyString %s/\"\(\(.*#{.*\)\@!\&\([^'"]*\)\)\"/'\1'/egc
    endfunction

    augroup FiletypeSettingsPluginRubyConverters
        autocmd!
        autocmd FileType ruby,eruby,haml call s:SetupRubyConverters()
    augroup END
endif
" }


" RSpec Converters {
if get(g:, 'enable_rspec_converters', 1)
    function! s:convert_rspec_syntax(old_syntax, expect, receive, bang) abort
        let prefix = '%s/\A\zs\([^ ]\+\)'
        let suffix = a:old_syntax . '/' . a:expect . '(\1)\.' . a:receive . '/eg' . (a:bang ? '' : 'c')

        let cmd =  prefix . '\.' . suffix
        execute cmd

        let cmd =  prefix . '\n\s\+\.' . suffix
        execute cmd

        let cmd =  prefix . '\.\n\s\+' . suffix
        execute cmd
    endfunction

    function! s:convert_rspec_any_instance_should_receive(args, bang) abort
        let expect = empty(a:args) ? 'expect_any_instance_of' : a:args
        call s:convert_rspec_syntax('any_instance\.should_receive', expect, 'to receive', a:bang)
    endfunction

    function! s:convert_rspec_any_instance_stub(args, bang) abort
        let expect = empty(a:args) ? 'allow_any_instance_of' : a:args
        call s:convert_rspec_syntax('any_instance\.stub', expect, 'to receive', a:bang)
    endfunction

    function! s:convert_rspec_should_receive(args, bang) abort
        let expect = empty(a:args) ? 'expect' : a:args
        call s:convert_rspec_syntax('should_receive', expect, 'to receive', a:bang)
    endfunction

    function! s:convert_rspec_should_not_receive(args, bang) abort
        let expect = empty(a:args) ? 'expect' : a:args
        call s:convert_rspec_syntax('should_not_receive', expect, 'not_to receive', a:bang)
    endfunction

    function! s:convert_rspec_stub_chain(args, bang) abort
        let expect = empty(a:args) ? 'allow' : a:args
        call s:convert_rspec_syntax('stub_chain', expect, 'to receive_message_chain', a:bang)
    endfunction

    function! s:convert_rspec_stub_messages(args, bang) abort
        let expect = empty(a:args) ? 'allow' : a:args
        call s:convert_rspec_syntax('stub', expect, 'to receive_messages', a:bang)
    endfunction

    function! s:convert_rspec_stub(args, bang) abort
        let expect = empty(a:args) ? 'allow' : a:args
        call s:convert_rspec_syntax('stub', expect, 'to receive', a:bang)
    endfunction

    function! s:ListRSpecActions(A, L, P) abort
        return ['expect', 'expect_any_instance_of', 'allow', 'allow_any_instance_of']
    endfunction

    function! s:SetupRSpecConverts() abort
        command! -buffer -bang -bar -nargs=? -complete=customlist,<SID>ListRSpecActions
                    \ ConvertRSpecAnyInstanceShouldReceive  call <SID>convert_rspec_any_instance_should_receive(<q-args>, <bang>0)
        command! -buffer -bang -bar -nargs=? -complete=customlist,<SID>ListRSpecActions
                    \ ConvertRSpecAnyInstanceStub           call <SID>convert_rspec_any_instance_stub(<q-args>, <bang>0)
        command! -buffer -bang -bar -nargs=? -complete=customlist,<SID>ListRSpecActions
                    \ ConvertRSpecShouldReceive             call <SID>convert_rspec_should_receive(<q-args>, <bang>0)
        command! -buffer -bang -bar -nargs=? -complete=customlist,<SID>ListRSpecActions
                    \ ConvertRSpecShouldNotReceive          call <SID>convert_rspec_should_not_receive(<q-args>, <bang>0)
        command! -buffer -bang -bar -nargs=? -complete=customlist,<SID>ListRSpecActions
                    \ ConvertRSpecStubChain                 call <SID>convert_rspec_stub_chain(<q-args>, <bang>0)
        command! -buffer -bang -bar -nargs=? -complete=customlist,<SID>ListRSpecActions
                    \ ConvertRSpecStubMessages              call <SID>convert_rspec_stub_messages(<q-args>, <bang>0)
        command! -buffer -bang -bar -nargs=? -complete=customlist,<SID>ListRSpecActions
                    \ ConvertRSpecStub                      call <SID>convert_rspec_stub(<q-args>, <bang>0)
    endfunction

    augroup FiletypeSettingsPluginRSpecConverters
        autocmd!
        autocmd BufNewFile,BufRead *_spec.rb call s:SetupRSpecConverts()
    augroup END
endif
" }

let g:loaded_filetype_settings = 1
