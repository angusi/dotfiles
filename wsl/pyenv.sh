if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT=$HOME/.pyenv
    export PATH=$HOME/.pyenv/bin:$PATH
    eval "$(pyenv init - zsh)"
else
    echo "pyenv not found"
fi
