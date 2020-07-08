if [[ "$(hostname -s)" == "PC5"* ]]; then
    alias sbt="sbt -ivy /c/Users/aai/.ivy2 -sbt-dir /home/aai/.sbt -sbt-boot /home/aai/.sbt/boot"
fi
alias ssh="ssh -F ~/.sshconfig"
alias scp="scp -F ~/.sshconfig"
alias mosh="mosh --ssh \"ssh -F ~/.sshconfig\""
alias subl="\"/c/Program Files/Sublime Text 3/subl.exe\""

alias drop_cache="sudo sh -c \"echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'\""
