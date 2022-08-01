export EDITOR=nvim
alias ll='ls -l'
alias lla='ls -la'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Use vi modes in command line and change keybindings for Colemak
bindkey -v
bindkey -M vicmd "j" vi-repeat-search
bindkey -M vicmd "J" vi-rev-repeat-search
bindkey -M vicmd "^J" down-history
bindkey -M vicmd "l" vi-forward-word-end
bindkey -M vicmd "L" vi-forward-blank-word-end
bindkey -M vicmd "h" vi-insert
bindkey -M vicmd "H" vi-insert-bol
bindkey -M vicmd "k" vi-open-line-below
bindkey -M vicmd "K" vi-open-line-above
bindkey -M vicmd "n" vi-backward-char
bindkey -M vicmd "e" down-line-or-history
bindkey -M vicmd "E" vi-join
bindkey -M vicmd "i" up-line-or-history
bindkey -M vicmd "o" vi-forward-char

export PATH="/opt/homebrew/bin:/usr/local/sbin:$PATH"
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
