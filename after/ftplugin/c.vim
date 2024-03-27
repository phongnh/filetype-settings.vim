setlocal commentstring=//\ %s
setlocal foldmethod=marker foldmarker={,}
if exists('+omnifunc') && &omnifunc ==# 'ccomplete#Complete'
    setlocal omnifunc=
endif
