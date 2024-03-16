export ZSH="$HOME/.oh-my-zsh"

path+=($HOME'/bin')
path+=($HOME'/.local/bin')
path+=('/usr/local/bin')
path+=($HOME'/.local/share/bob/nvim-bin')

ZSH_THEME="obergodmar"
ZSH_DISABLE_COMPFIX=true

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setopt histignoredups
setopt ignoreeof

alias lg="lazygit"

function rename_wezterm_title {
  echo "\x1b]1337;SetUserVar=panetitle=$(echo -n $1 | base64)\x07"
}

lazynvm() {
  unset -f nvm node npm npx
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}

npx() {
  lazynvm
  npx $@
}

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
gvm use default >/dev/null

export PATH
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

[[ -s "/home/obergodmar/.gvm/scripts/gvm" ]] && source "/home/obergodmar/.gvm/scripts/gvm"
