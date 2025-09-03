# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv context dir vcs)
POWERLEVEL9K_VIRTUALENV_BACKGROUND='black'
POWERLEVEL9K_VIRTUALENV_FOREGROUND='037'

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
eval "$(navi widget zsh)"
plugins=(git httpie zoxide)

# User configuration

export PATH=/usr/local/bin:$HOME/bin:/$HOME/.local/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"
export PERL5LIB=/usr/lib/perl5/vendor_perl/5.22
export SHELL="/bin/zsh"

source $ZSH/oh-my-zsh.sh

eval $(thefuck --alias)

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function huilog () {
    LAST_LOG=$(exa -rs modified data/logs | grep -v 'story' | head -n 1)
    echo $LAST_LOG
    less data/logs/${LAST_LOG}
}

# OS-specific environments
if uname -a | grep -q '^Linux.*[Mm]icrosoft' ; then
    # WSL
    . ~/.dotfiles/wsl/init.sh
fi

if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
else
    printf "\033[1;33mWARNING:\033[0;33m fzf isn't install (or configured)\033[0m\n"
fi

[ -f /etc/bash_completion.d/azure-cli ] && source /etc/bash_completion.d/azure-cli

PATH="/home/aai/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/aai/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/aai/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/aai/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/aai/perl5"; export PERL_MM_OPT;
