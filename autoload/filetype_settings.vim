" Bar Align {
function! filetype_settings#bar_align() abort
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfunction
" }

" Ruby Converts {
function! filetype_settings#setup_ruby_converters() abort
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
" }

" RSpec Converters {
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

function! filetype_settings#setup_rspec_converters() abort
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
