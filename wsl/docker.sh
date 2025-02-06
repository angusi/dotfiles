HOSTNAME="$(hostname -s)"
if [[ "$HOSTNAME" == "PC5"* || "$HOSTNAME" == "DESKTOP-"* || "$HOSTNAME" == "beinn"* ]]; then
    sudo service docker start
fi
