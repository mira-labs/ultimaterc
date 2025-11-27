# ~/.bashrc for RedHat/CentOS/Fedora

# Colors for prompt
PS1='\[\e[36m\]\w\[\e[0m\] \[\e[33m\]$(git branch 2>/dev/null | grep "*" | sed "s/* //")\[\e[0m\] \[\e[32m\]$\[\e[0m\] '

# Aliases
alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo dnf update && sudo dnf upgrade'
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
alias pk='pkill -i'
alias k9='kill -9'
alias k9n='kill -9 $(pgrep -f)'


# Install script for RedHat/CentOS/Fedora: only install if missing
function install_tools_redhat_once() {
  local pkgs=(coreutils git bat exa fd-find ripgrep fzf htop tldr thefuck ncdu glow btop)
  local missing=()
  for pkg in "${pkgs[@]}"; do
    if ! command -v "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo "Installing missing tools: ${missing[*]}"
    sudo dnf install -y "${missing[@]}"
  fi
}
# Auto-install missing tools only once per session
if [ -z "$BASHRC_REDHAT_TOOLS_INSTALLED" ]; then
  install_tools_redhat_once
  export BASHRC_REDHAT_TOOLS_INSTALLED=1
fi
