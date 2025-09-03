# Function to load encrypted password into environment variable
# Usage: load_encrypted_password <encrypted_file_path> <env_var_name>
# Example: load_encrypted_password ~/.config/db_password.gpg DB_PASSWORD
# Ensure gpg-agent is running first!
load_encrypted_password() {
    local encrypted_file="$1"
    local env_var_name="$2"

    # Check if both arguments are provided
    if [[ -z "$encrypted_file" || -z "$env_var_name" ]]; then
        echo "Usage: load_encrypted_password <encrypted_file_path> <env_var_name>"
        return 1
    fi

    # Check if encrypted file exists
    if [[ ! -f "$encrypted_file" ]]; then
        echo "Error: Encrypted file '$encrypted_file' not found"
        return 1
    fi

    # Decrypt the password
    local decrypted_value
    decrypted_value=$(gpg --quiet --decrypt "$encrypted_file" 2>/dev/null)

    if [[ $? -eq 0 && -n "$decrypted_value" ]]; then
        # Use zsh parameter expansion to set the environment variable dynamically
        export ${env_var_name}="$decrypted_value"
	printf "\033[1;32mINFO:   \033[0;32m Successfully loaded ${env_var_name} from ${encrypted_file}.\033[0m\n"
        return 0
    else
        printf "\033[1;31mERROR:  \033[0;31m Failed to decrypt ${encrypted_file} (or file is empty).\033[0m\n"
        return 1
    fi
}


######
# Apt Auth
######

# APT Authentication Proxy Manager Functions
# Manages a local proxy that adds authentication headers without storing passwords on disk

# Global variables for proxy management
APT_PROXY_PID=""
APT_PROXY_PORT=""
APT_PROXY_SCRIPT="$HOME/bin/apt-auth-proxy.py"

# Function to start the authentication proxy
start_apt_proxy() {
    # Check if proxy is already running
    if [[ -n "$APT_PROXY_PID" ]] && kill -0 "$APT_PROXY_PID" 2>/dev/null; then
        printf "\033[1;32mINFO:   \033[0;32m apt proxy already running on port ${APT_PROXY_PORT} (PID ${APT_PROXY_PID}.\033[0m\n"
        return 0
    fi

    # Find a free port
    APT_PROXY_PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('',0)); print(s.getsockname()[1]); s.close()")

    # Start the proxy in the background
    "$APT_PROXY_SCRIPT" "$APT_PROXY_PORT" &
    APT_PROXY_PID=$!

    # Wait a moment for the proxy to start
    sleep 1

    # Check if it's running
    if kill -0 "$APT_PROXY_PID" 2>/dev/null; then
        printf "\033[1;32mINFO:   \033[0;32m apt proxy started on port ${APT_PROXY_PORT} (PID ${APT_PROXY_PID}.\033[0m\n"

        # Configure apt to use the proxy
        configure_apt_proxy
        return 0
    else
        printf "\033[1;31mERROR:  \033[0;31m Failed to start apt proxy on port ${APT_PROXY_PORT}.\033[0m\n"
        APT_PROXY_PID=""
        APT_PROXY_PORT=""
        return 1
    fi
}

# Function to stop the authentication proxy
stop_apt_proxy() {
    if [[ -n "$APT_PROXY_PID" ]] && kill -0 "$APT_PROXY_PID" 2>/dev/null; then
        kill "$APT_PROXY_PID"
        printf "\033[1;32mINFO:   \033[0;32m apt proxy stopped (PID ${APT_PROXY_PID}.\033[0m\n"
    fi

    # Remove apt proxy configuration
    remove_apt_proxy_config

    APT_PROXY_PID=""
    APT_PROXY_PORT=""
}

# Function to configure apt to use the proxy
configure_apt_proxy() {
    if [[ -z "$APT_PROXY_PORT" ]]; then
        printf "\033[1;31mERROR:  \033[0;31m apt proxy port not set.\033[0m\n"
        return 1
    fi

    # Create apt proxy configuration
    local proxy_conf="/etc/apt/apt.conf.d/01-auth-proxy"

    printf "\033[1;32mINFO:   \033[0;32m Configuring apt to use authentication proxy...\033[0m\n"
    sudo tee "$proxy_conf" > /dev/null << EOF
Acquire::http::Proxy "http://127.0.0.1:$APT_PROXY_PORT";
Acquire::https::Proxy "DIRECT";
Acquire::https::alianza.jfrog.io::Proxy "http://127.0.0.1:$APT_PROXY_PORT/";
Acquire::https::alianza.jfrog.io "http://TLSUPGRADE/alianza.jfrog.io";

EOF

    printf "\033[1;32mINFO:   \033[0;32m apt configured to use proxy on port ${APT_PROXY_PORT}.\033[0m\n"
}

# Function to remove apt proxy configuration
remove_apt_proxy_config() {
    local proxy_conf="/etc/apt/apt.conf.d/01-auth-proxy"
    if [[ -f "$proxy_conf" ]]; then
        sudo rm -f "$proxy_conf"
	printf "\033[1;32mINFO:   \033[0;32m Removed apt proxy configuration.\033[0m\n"
    fi
}

# Function to set repository authentication for specific hosts
set_repository_auth() {
    local hostname="$1"
    local username="$2"
    local password_env_var="$3"

    if [[ -z "$hostname" || -z "$username" || -z "$password_env_var" ]]; then
        echo "Usage: set_repository_auth <hostname> <username> <password_env_var>"
        echo "Example: set_repository_auth repo.example.com myuser REPO_PASSWORD"
        return 1
    fi

    # Get the password from the environment variable
    local password="${(P)password_env_var}"

    if [[ -z "$password" ]]; then
        printf "\033[1;31mERROR:  \033[0;31m Environment variable ${password_env_var} is not set (or is empty).\033[0m\n"
        return 1
    fi

    # Set environment variables for the proxy to use
    local hostname_env=$(echo "$hostname" | sed 's/[.-]/_/g' | tr '[:lower:]' '[:upper:]')
    export "REPO_AUTH_${hostname_env}_USER=$username"
    export "REPO_AUTH_${hostname_env}_PASS=$password"

    printf "\033[1;32mINFO:   \033[0;32m Set authentication for ${hostname} (user: ${username}).\033[0m\n"
}

# Function to set generic repository authentication
set_generic_repository_auth() {
    local username="$1"
    local password_env_var="$2"

    if [[ -z "$username" || -z "$password_env_var" ]]; then
        echo "Usage: set_generic_repository_auth <username> <password_env_var>"
        return 1
    fi

    local password="${(P)password_env_var}"

    if [[ -z "$password" ]]; then
        printf "\033[1;31mERROR:  \033[0;31m Environment variable ${password_env_var} is not set (or is empty).\033[0m\n"
        return 1
    fi

    export REPO_USER="$username"
    export REPO_PASSWORD="$password"

    printf "\033[1;32mINFO:   \033[0;32m Set generic authentication (user: ${username}).\033[0m\n"
}

# Function to manage apt with authentication
apt_with_auth() {
    # Start proxy if not running
    if [[ -z "$APT_PROXY_PID" ]] || ! kill -0 "$APT_PROXY_PID" 2>/dev/null; then
        start_apt_proxy || return 1
    fi

    # Run apt command
    sudo apt "$@"
}

# Cleanup function to stop proxy on shell exit
cleanup_apt_proxy() {
    if [[ -n "$APT_PROXY_PID" ]] && kill -0 "$APT_PROXY_PID" 2>/dev/null; then
        stop_apt_proxy
    fi
}

# Register cleanup function
trap cleanup_apt_proxy EXIT

# Auto-start proxy function (call this in your .zshrc)
auto_start_apt_proxy() {
    # Only start if we have repository credentials loaded
    if [[ -n "$REPO_PASSWORD" ]] || env | grep -q "REPO_AUTH_.*_PASS"; then
        setup_apt_proxy
        start_apt_proxy
    fi
}

######
# Use above scripts
######


if [[ -f ~/.config/gpg-creds/jfrog.gpg ]]; then
    load_encrypted_password ~/.config/gpg-creds/jfrog.gpg JFROG_FEED_PAT
    export JFROG_PASSWORD=$JFROG_FEED_PAT
    export CARGO_REGISTRIES_ALIANZA_TOKEN="Bearer $JFROG_FEED_PAT"
    export CARGO_REGISTRIES_ALIANZA_CRATES_IO_TOKEN="Bearer $JFROG_FEED_PAT"
    set_repository_auth alianza.jfrog.io angus.ireland JFROG_FEED_PAT
    export POETRY_HTTP_BASIC_NF_PYPI_LOCAL_USERNAME=$REPO_AUTH_ALIANZA_JFROG_IO_USER
    export POETRY_HTTP_BASIC_NF_PYPI_LOCAL_PASSWORD=$REPO_AUTH_ALIANZA_JFROG_IO_PASS
    export POETRY_HTTP_BASIC_NF_PYPI_REMOTE_USERNAME=$REPO_AUTH_ALIANZA_JFROG_IO_USER
    export POETRY_HTTP_BASIC_NF_PYPI_REMOTE_PASSWORD=$REPO_AUTH_ALIANZA_JFROG_IO_PASS
fi
