# ohmyzsh setting https://github.com/ohmyzsh/ohmyzsh/wiki/Settings
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH=$HOME/.homedir:$PATH
export JAVA_HOME=$HOME/OpenJDK/jdk-20.0.2.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="geoffgarside"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias python="python3"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | lolcat"
alias django="python manage.py"
alias venv-on='source $(git rev-parse --show-toplevel)/.venv/bin/activate'
alias cdr='cd $(git rev-parse --show-toplevel)'

# Tmux session management
alias byobu=tmux
alias td="tmux detach"
alias tl="tmux ls"

# Tmux attach function - attach to specified session
unalias ta 2>/dev/null || true
ta() {
    if [ -z "$1" ]; then
        tmux attach
    else
        tmux attach -t "$1"
    fi
}

# Tmux new function - create new session with optional name
tn() {
    if [ -z "$1" ]; then
        tmux new
    else
        tmux new -s "$1"
    fi
}

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Only initialize thefuck if it's installed
if command -v thefuck &> /dev/null; then
    eval $(thefuck --alias)
fi

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# Source machine-specific configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local