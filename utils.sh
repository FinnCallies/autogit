function warn() {
    echo "[ WARN  ]: $*"
}

function err() {
    echo "[ ERROR ]: $*"
    exit 1
}

function info() {
    echo "[ INFO  ]: $*"
}

LOCAL_STORE="${HOME}/.local/etc/autogit.store"