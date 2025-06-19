set fish_greeting

# Utils
alias ls lsd
alias find fd
alias finder fzf
alias reload 'source ~/.config/fish/config.fish'


# NixOS
function rebuild-test 
    cd ~/dotfiles && addall && sudo nixos-rebuild test --flake ~/dotfiles#(hostname)
    reload
end

function rebuild-update 
    cd ~/dotfiles && pull && sudo nixos-rebuild switch --flake ~/dotfiles#(hostname)
end

function rebuild-commit 
    cd ~/dotfiles && commit $argv && sudo nixos-rebuild switch --flake ~/dotfiles#(hostname) && push
end

# Git
alias addall 'git add -A'
alias pull 'git pull --rebase'
alias push 'git push -u origin (git branch --show-current)'
alias commit 'git commit'


function br --wraps=broot
    set -l cmd_file (mktemp)
    if broot --outcmd $cmd_file $argv
        source $cmd_file
        rm -f $cmd_file
    else
        set -l code $status
        rm -f $cmd_file
        return $code
    end
end