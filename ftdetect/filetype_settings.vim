augroup FiletypeSettingsDetect
    autocmd!
    autocmd BufNewFile,BufRead *.nvim,{.,}init.vim.*,{.,}vimrc.* setfiletype vim
    autocmd BufNewFile,BufRead *.fastercsv,*.prawn,{*.,}pryrc*,{*.,}irbrc*,{*.,}railsrc* setfiletype ruby
    autocmd BufNewFile,BufRead *.zsh-theme setfiletype zsh
    autocmd BufNewFile,BufRead {,*}.tigrc setfiletype tigrc
    autocmd BufNewFile,BufRead *.inky-haml,*.haml,*.hamlbars,*.hamlc setfiletype haml
    autocmd BufNewFile,BufRead .gemrc setfiletype yaml
    autocmd BufNewFile,BufRead *.html.inky setfiletype html.eruby
    autocmd BufNewFile,BufRead *.tmux.conf setfiletype tmux
augroup END
