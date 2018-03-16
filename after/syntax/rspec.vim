setlocal tabstop=2 shiftwidth=2

let b:surround_{char2nr('a')} = "allow(\r)"
let b:surround_{char2nr('A')} = "allow_any_instance_of(\r)"
let b:surround_{char2nr('e')} = "expect(\r)"
let b:surround_{char2nr('E')} = "expect_any_instance_of(\r)"
let b:surround_{char2nr('c')} = "expect { \r }"

if get(g:, 'enable_rspec_converters')
    call filetype_settings#setup_rspec_converters()
endif
