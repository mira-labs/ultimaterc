# ~/.zshrc configuration

# Autocomplete/color tools (brew installs):
# brew install coreutils
# brew install zsh-completions
# brew install zsh-autosuggestions
# brew install zsh-syntax-highlighting

# Modern terminal tools (brew installs):
# brew install bat exa fd ripgrep fzf htop tldr thefuck ncdu glow btop

# Function to auto-install missing autocomplete/color and modern tools
autoload_packages=(coreutils zsh-completions zsh-autosuggestions zsh-syntax-highlighting bat exa fd ripgrep fzf htop tldr thefuck ncdu glow btop)
# Standard Homebrew install paths
BREW_PREFIX="$(brew --prefix)"
BREW_BIN="$BREW_PREFIX/bin"
BREW_OPT="$BREW_PREFIX/opt"

function ensure_brew_packages_installed() {
	local updated_path=0
	for pkg in "${autoload_packages[@]}"; do
		if ! brew list "$pkg" &>/dev/null; then
			echo "Installing $pkg via Homebrew..."
			brew install "$pkg"
		fi
		# Check for binaries in standard locations and update PATH if needed
		if [ -d "$BREW_OPT/$pkg/bin" ] && [[ ":$PATH:" != *":$BREW_OPT/$pkg/bin:"* ]]; then
			export PATH="$BREW_OPT/$pkg/bin:$PATH"
			updated_path=1
		elif [ -d "$BREW_BIN" ] && [[ ":$PATH:" != *":$BREW_BIN:"* ]]; then
			export PATH="$BREW_BIN:$PATH"
			updated_path=1
		fi
	done
	if [ $updated_path -eq 1 ]; then
		echo "Updated PATH to include Homebrew binaries."
	fi
}
# Uncomment to auto-install on shell startup (may slow login):
# ensure_brew_packages_installed

# Function to check all commands used in aliases and install if missing
function ensure_alias_commands_installed() {
	local cmds=(ls bat exa fd ripgrep rg fzf htop tldr thefuck ncdu glow btop git brew)
	for cmd in "${cmds[@]}"; do
		if ! command -v "$cmd" &>/dev/null; then
			echo "Command $cmd not found. Attempting to install via Homebrew..."
			brew install "$cmd"
		fi
	done
}
# Uncomment to auto-install alias commands on shell startup (may slow login):
# ensure_alias_commands_installed

# Function to auto-install missing autocomplete/color packages
autoload_packages=(coreutils zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
function ensure_brew_packages_installed() {
	for pkg in "${autoload_packages[@]}"; do
		if ! brew list "$pkg" &>/dev/null; then
			echo "Installing $pkg via Homebrew..."
			brew install "$pkg"
		fi
	done
}
# Uncomment to auto-install on shell startup (may slow login):
# ensure_brew_packages_installed

# Prompt: Show current directory and git branch, with colors, no hostname
autoload -Uz vcs_info
precmd() { vcs_info }

# Colors
autoload -U colors && colors
setopt PROMPT_SUBST

# Color codes
DIR_COLOR='%F{cyan}'
BRANCH_COLOR='%F{yellow}'
RESET_COLOR='%f'
PROMPT_SYMBOL='%F{green}❯%f'

# Git branch extraction
GIT_BRANCH='${vcs_info_msg_0_}'

# PS1 prompt
export PS1="${DIR_COLOR}%~${RESET_COLOR} ${BRANCH_COLOR}${GIT_BRANCH}${RESET_COLOR} ${PROMPT_SYMBOL} "

# Useful aliases
alias ll='ls -lh'
alias la='ls -lha'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias ..='cd ..'
alias ...='cd ../..'
alias update='brew update && brew upgrade'

# Short aliases for regular commands
alias c='clear'
alias e='exit'
alias h='history'
alias v='vim'
alias j='jobs'
alias k='kill'
alias x='exit'
alias d='cd'
alias p='pwd'
alias m='man'

# Aliases for killing processes by name
alias pk='pkill -i'
alias k9='kill -9'
alias k9n='noglob kill -9 $(pgrep -f)'
# Usage: k9n processname

# Modern tool aliases
alias cat='bat'
alias ls='exa --color=auto --group-directories-first'
alias l='exa -l --git'
alias la='exa -la --git'
alias tree='exa --tree --level=2'
alias find='fd'
alias grep='rg'
alias top='htop'
alias duh='ncdu'
alias mdview='glow'
alias pmon='btop'
alias fuck='thefuck'
alias tldr='tldr'
alias fz='fzf'
alias rr='rm -rf'


# Enable completion
autoload -Uz compinit && compinit

# Enable autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
	source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Enable syntax highlighting
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Other options
setopt autocd
setopt correct
setopt no_beep

# Source user local config if exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
