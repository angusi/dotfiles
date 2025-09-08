_dotfiles_log_info() {
    local log_text="$1"

    printf "\033[1;32mINFO:   \033[0;32m ${log_text}\033[0m\n"
}

_dotfiles_log_error() {
    local log_text="$1"

    printf "\033[1;31mERROR:  \033[0;31m ${log_text}\033[0m\n"
}