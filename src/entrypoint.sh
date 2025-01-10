#!/usr/bin/env bash

ENTRYPOINT_USERNAME=ubuntu

NEW_UID="${HOST_UID:-$(id -u "${ENTRYPOINT_USERNAME}")}" # Use the environment variable value or default (1000) if variable is not set.
NEW_GID=${HOST_GID:-$(id -g "${ENTRYPOINT_USERNAME}")}   # Use the environment variable value or default (1000) if variable is not set.

usermod -o -u "${NEW_UID}" "${ENTRYPOINT_USERNAME}" 1>/dev/null  # Modify the user id.
groupmod -o -g "${NEW_GID}" "${ENTRYPOINT_USERNAME}" 1>/dev/null # Modify the group id.

printf "User '%s' is running with the following IDs:\n" "${ENTRYPOINT_USERNAME}"
printf "\tUID: %s\n" $(id -u "${ENTRYPOINT_USERNAME}")
printf "\tGID: %s\n" $(id -u "${ENTRYPOINT_USERNAME}")

gosu "${ENTRYPOINT_USERNAME}" "$@" # Run the command the entrypoint was called with as the custom user.
