if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal keywordprg=:help
setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
