augroup FiletypeSettingsDetect
    autocmd!
    autocmd BufNewFile,BufRead *.nvim,.init.vim.*,.vimrc.* setfiletype vim
    autocmd BufNewFile,BufRead *.fastercsv,*.prawn,{*.,}pryrc*,{*.,}irbrc*,{*.,}railsrc* setfiletype ruby
    autocmd BufNewFile,BufRead *.zsh-theme setfiletype zsh
    autocmd BufNewFile,BufRead {,*}.tigrc setfiletype tigrc
    autocmd BufNewFile,BufRead *.inky-haml,*.hamlc setfiletype haml
    autocmd BufNewFile,BufRead *.tmux.conf setfiletype tmux
augroup END
