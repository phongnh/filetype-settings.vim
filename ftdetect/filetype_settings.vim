augroup FiletypeSettingsDetect
    autocmd!
    autocmd BufNewFile,BufRead *.nvim set filetype=vim
    autocmd BufNewFile,BufRead *.neovim set filetype=vim
    autocmd BufNewFile,BufRead *.fastercsv,*.prawn set filetype=ruby
augroup END
