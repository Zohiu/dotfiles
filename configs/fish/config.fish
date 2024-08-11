## Set values

# Hide welcome message
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"

set -gx MANPAGER most 


## Environment setup
if test -f ~/.fish_profile
  source ~/.fish_profile
end


# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end


## Advanced command-not-found hook
source /usr/share/doc/find-the-command/ftc.fish


## Functions
function fish_greeting
    clear
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end



## Aliases
alias update='~/config/update.sh'

# Replace ls with exa
alias ls='exa -a --color=always --group-directories-first --icons' # preferred listing
alias lp='exa -al --color=always --group-directories-first --icons' # preferred listing
alias tree='exa -aT --color=always --group-directories-first --icons' # tree listing

# Replace some more things with better alternatives
alias cat='bat --style header --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'
alias nano=micro


# Common use
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'
alias hw='hwinfo --short'                          # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"     # Sort installed packages according to size in MB


# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrorsort="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"


# Fun stuff
alias please='sudo'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias recent="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"


# Start sway if just booted
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec dbus-run-session sway
    end
end

# This creates that annoying message which is why I clear the terminal on start
xhost +local:
