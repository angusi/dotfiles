if [[ "$(hostname -s)" == "PC5"* ]]; then
#    export DOCKER_TLS_VERIFY=""
#    export DOCKER_HOST="tcp://0.0.0.0:2375"
    #export DOCKER_CERT_PATH="/mnt/c/Users/aai/.docker/machine/machines/default"
    #export DOCKER_MACHINE_NAME="default"
    #export COMPOSE_CONVERT_WINDOWS_PATHS="true"
    sudo service docker start
fi
