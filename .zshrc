export EDITOR=nvim
set -o vi
alias ll='ls -l'
alias lla='ls -la'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

export PATH="/usr/local/sbin:$PATH"
export NVIM_HOME=~/.config/nvim
export MAVEN_HOME=~/apache-maven-3.8.1
export PATH="$PATH:$MAVEN_HOME/bin"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

autoload -Uz vcs_info # enable vcs_info
zstyle ":vcs_info:*" formats " %s(%F{red}%b%f)" # git(main)
precmd() {
	vcs_info
	if [[ -z ${vcs_info_msg_0_} ]]; then
		# Oh hey, nothing from vcs_info, so we got more space.
		# Let's print a longer part of $PWD...
		PS1="%n@%m [%F{red}%5~%f]%# "
	else
		# vcs_info found something, that needs space. So a shorter $PWD
		# makes sense.
		PS1="%n@%m [%F{red}%3~%f]${vcs_info_msg_0_}%# "
	fi
}
