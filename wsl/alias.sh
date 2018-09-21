if [[ "$(hostname -s)" == "PC5"* ]]; then
    alias sbt="sbt -ivy /mnt/c/Users/aai/.ivy2 -sbt-dir /home/aai/.sbt -sbt-boot /home/aai/.sbt/boot"
fi
alias ssh="ssh -F ~/.sshconfig"
alias scp="scp -F ~/.sshconfig"
alias mosh="mosh --ssh \"ssh -F ~/.sshconfig\""
alias subl="\"/mnt/c/Program Files/Sublime Text 3/subl.exe\""
