augroup FiletypeSettingsDetect
    autocmd!
    autocmd BufNewFile,BufRead {*.,}vimrc.{bundles,local} setfiletype vim
    autocmd BufNewFile,BufRead {*.,}{init,editor}.lua.{bundles,local} setfiletype lua
    autocmd BufNewFile,BufRead *.gemfile,*.fastercsv,*.prawn,{*.,}pryrc*,{*.,}irbrc*,{*.,}railsrc* setfiletype ruby
    autocmd BufNewFile,BufRead *.zsh-theme setfiletype zsh
    autocmd BufNewFile,BufRead {,*}.tigrc setfiletype tigrc
    autocmd BufNewFile,BufRead *.inky-haml,*.haml,*.hamlbars,*.hamlc setfiletype haml
    autocmd BufNewFile,BufRead .gemrc setfiletype yaml
    autocmd BufNewFile,BufRead *.html.inky setlocal filetype=html.eruby
    autocmd BufNewFile,BufRead *.tmux.conf setfiletype tmux
    autocmd BufNewFile,BufRead */kitty/*.conf setfiletype conf
augroup END
