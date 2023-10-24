#!/bin/bash

read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        exit 0
        ;;
    *)
        exit 1
        ;;
esac