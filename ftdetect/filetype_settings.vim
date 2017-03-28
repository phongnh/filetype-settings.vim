augroup FiletypeSettingsDetect
    autocmd!
    autocmd BufNewFile,BufRead *.nvim setlocal filetype=vim
    autocmd BufNewFile,BufRead *.fastercsv,*.prawn setlocal filetype=ruby
augroup END
