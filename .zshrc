export ZSH="$HOME/.oh-my-zsh"
export BUN_INSTALL="$HOME/.bun"
export CARGO_HOME="$HOME/.cargo"

path+=($HOME'/bin')
path+=($HOME'/.local/bin')
path+=('/usr/local/bin')
path+=($HOME'/.local/share/bob/nvim-bin')
path+=($BUN_INSTALL'/bin')
path+=($HOME'/.cargo/bin')

export PATH

ZSH_THEME="obergodmar"
ZSH_DISABLE_COMPFIX=true

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

setopt histignoredups
setopt ignoreeof

if
	[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] &&
		[[ -f /usr/share/doc/fzf/examples/completion.zsh ]]
then
	source /usr/share/doc/fzf/examples/key-bindings.zsh
	source /usr/share/doc/fzf/examples/completion.zsh
elif [[ -f $HOME/.fzf.zsh ]]; then
	source $HOME/.fzf.zsh
fi

if [[ -f $HOME/.aliases ]]; then
	source $HOME/.aliases
fi

alias lg="lazygit"
alias ls="eza --tree --level=1 --icons=always"
alias vim="nvim"
alias tmux="tmux -2"

function rename_wezterm_title {
	echo "\x1b]1337;SetUserVar=panetitle=$(echo -n $1 | base64)\x07"
}

function change_wezterm_colorscheme {
	echo "\033]1337;SetUserVar=colorscheme=$(echo -n "update" | base64)\007"
}

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if [[ -s "$HOME/.gvm/scripts/gvm" ]]; then
	source "$HOME/.gvm/scripts/gvm"
	gvm use default >/dev/null
fi

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
