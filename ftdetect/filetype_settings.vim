augroup FiletypeSettingsDetect
    autocmd!
    autocmd BufNewFile,BufRead *.nvim,*.neovim setfiletype vim
    autocmd BufNewFile,BufRead .init.vim.*,.vimrc.* setfiletype vim
    autocmd BufNewFile,BufRead *.fastercsv,*.prawn setfiletype ruby
    autocmd BufNewFile,BufRead {*.,}pryrc*,{*.,}irbrc*,{*.,}railsrc* setfiletype ruby
    autocmd BufNewFile,BufRead *.zsh-theme setfiletype zsh
augroup END
