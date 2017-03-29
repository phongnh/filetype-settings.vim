augroup FiletypeSettingsDetect
    autocmd!
    autocmd BufNewFile,BufRead *.nvim,*.neovim set filetype=vim
    autocmd BufNewFile,BufRead *.fastercsv,*.prawn set filetype=ruby
augroup END
