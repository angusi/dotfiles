if [[ "$(hostname -s)" == "PC5"* ]]; then
    alias sbt="sbt -ivy /c/Users/aai/.ivy2 -sbt-dir /home/aai/.sbt -sbt-boot /home/aai/.sbt/boot"
fi

if [ -f ~/.sshconfig ]; then
    alias ssh="ssh -F ~/.sshconfig"
    alias scp="scp -F ~/.sshconfig"
else
    printf "\033[1;33mWARNING:\033[0;33m ~/.sshconfig doesn't exist?\033[0m\n"
fi

if command -v mosh >/dev/null 2>&1; then
    alias mosh="mosh --ssh \"ssh -F ~/.sshconfig\""
fi

if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
elif command -v exa >/dev/null 2>&1; then
    printf "\033[1;33mWARNING:\033[0;33m This system still uses exa - consider upgrading to eza\033[0m\n"
    alias ls="exa"
else
    printf "\033[1;33mWARNING:\033[0;33m eza is not installed - ls will be boring\033[0m\n"
fi
alias sls="/bin/ls"

alias drop_cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
