if [[ "$(hostname -s)" == "PC5"* ]]; then
    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://192.168.99.100:2376"
    export DOCKER_CERT_PATH="/mnt/c/Users/aai/.docker/machine/machines/default"
    export DOCKER_MACHINE_NAME="default"
    export COMPOSE_CONVERT_WINDOWS_PATHS="true"
fi
