#!/bin/bash

# Breadcrumbs for the shell
function ct {
    CD_PATH=$(pwd)
    FLAG=""

    # echo "Sanity check"
    if [ -z "$1" ]; then
        echo "You must supply a directory name"
        return
    fi

    while [ -z $FLAG ]; do
        if [ $(basename "$CD_PATH") = "${1}" ]; then
            FLAG="yes"
        else
            if [ "${CD_PATH}" = "/" ]; then
                FLAG="no"
            else
                CD_PATH=$(dirname "$CD_PATH")
            fi
        fi
    done

    # echo "found flag test"
    if [ $FLAG = "yes" ]; then
        cd "$CD_PATH"
        if [ -n "$2" ]; then
            cd "$2"
        fi
    else
        echo "'$1' not found in working directory path"
    fi
}

_ct()
{
    local abs_path="$(pwd)"
    local test_target=""
    local target=""

    while [ \( ! "/" = $abs_path \) -a \( -z "$target" \) ]; do
        test_target="$(basename "$abs_path")"
        if [[ "$test_target" =~ ${COMP_WORDS[$COMP_CWORD]} ]]; then
            target="$test_target"
        else
            abs_path="$(dirname $abs_path)"
        fi
    done
    COMPREPLY=( $target )
} && complete -F _ct ct
