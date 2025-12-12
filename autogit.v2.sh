#!/bin/bash

source $HOME/.local/include/autogit-utils.sh

function help() {
    echo "Usage: autogit CMD [ Project ]"
    echo "Management tool for git repositories"
    echo ""
    echo "commands:"
    echo "    help               print this help"
    echo "    ls                 list autogit entries"
    echo "    add [ Project ]    add new autogit entry for [ Project ]"
    echo "    rm  [ Project ]    remove autogit entry [ Project ]"
}

function ls() {
    cat "${LOCAL_STORE}"
}

function check_for_git() {
    if [[ $# -eq 0 ]]; then
        err "check_for_git: no repository specified"
        exit 1
    fi

    local repository="$1"

    if [[ ! -d "$repository" ]]; then
        err "$repository does not exist"
    fi

    if [[ ! -d "$repository/.git" ]]; then
        err "$repository is not a git repository"
    fi
}

function add() {
    if [[ $# -eq 0 ]]; then
        help
        exit 1
    fi

    local repository=$1

    if [[ "$repository" != /* ]]; then
        repository="$(pwd)/$repository"
    fi

    check_for_git "$repository"

    echo "$repository" >> "${LOCAL_STORE}"
    info "added autogit entry for $repository"
}

function rm() {
    if [[ $# -eq 0 ]]; then
        help
        exit 1
    fi

    local repository=$1

    sed -i "/^${repository//\//\\/}\$/d" "${LOCAL_STORE}"
}

function upload() {
    if [[ $# -eq 0 ]]; then
        exit 1
    fi

    local repository=$1

    check_for_git "$repository"

    local pwd=$(pwd)
    cd "$repository"

    git fetch
    if [[ -n $(git status --porcelain) ]]; then
        local date=$(date "+%Y-%m-%d %H:%M:%S")
        local msg="[ autogit ] $date"

        git add -A
        git commit -m "$msg"
    fi

    if [[ $(git status -sb | grep "ahead" --quiet) -eq 0 ]]; then
        local branch=$(git symbolic-ref --short HEAD)
        git push origin "$branch"
    fi

    cd "$pwd"
}

function download() {
    if [[ $# -eq 0 ]]; then
        exit 1
    fi

    local repository=$1

    check_for_git "$repository"

    local pwd=$(pwd)
    cd "$repository"

    git fetch

    local branch=$(git symbolic-ref --short HEAD)
    local behind=$(git rev-list --count HEAD..origin/$branch)

    if [[ $behind -gt 0 ]]; then
        git pull
    fi

    cd "$pwd"
}

#----- MAIN -----#

if [[ $# -eq 0 ]]; then
    help
    exit 1
fi

cmd=$1

if [[ $cmd == "help" ]]; then
    help
elif [[ $cmd == "ls" ]]; then
    ls
elif [[ $cmd == "add" ]]; then
    add "${@:2}"
elif [[ $cmd == "rm" ]]; then
    rm "${@:2}"
elif [[ $cmd == "upload" ]]; then
    while IFS= read -r line; do
        upload $line
    done < $LOCAL_STORE
elif [[ $cmd == "download" ]]; then
    while IFS= read -r line; do
        download $line
    done < $LOCAL_STORE
else
    err "Unknown command $cmd"
fi

exit 0
