export PATH=$HOME/bin:/usr/local/bin:~/.local/bin:$(go env GOPATH)/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="obergodmar"
ZSH_DISABLE_COMPFIX=true

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setopt histignoredups

function rename_wezterm_title {
    echo "\x1b]1337;SetUserVar=panetitle=$(echo -n $1 | base64)\x07"
}

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

alias up_hilbert="down_avenoir; sudo wg-quick up hilbert"
alias down_hilbert="sudo wg-quick down hilbert"

alias up_avenoir="down_hilbert; sudo wg-quick up avenoir"
alias down_avenoir="sudo wg-quick down avenoir"

alias wezterm="flatpak run org.wezfurlong.wezterm"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

[[ -s "/home/obergodmar/.gvm/scripts/gvm" ]] && source "/home/obergodmar/.gvm/scripts/gvm"
