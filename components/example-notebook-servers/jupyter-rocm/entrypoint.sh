#!/bin/bash

# Add render group if it doesn't exist
getent group $RENDER_GROUP_ID || groupadd --gid $RENDER_GROUP_ID render_host

# Add user to the group
usermod -aG $RENDER_GROUP_ID $NB_USER

# Reload group membership without logging out/in by starting a new shell
# that preserves the environment and executes the init process
sg $(getent group $RENDER_GROUP_ID | cut -d':' -f 1) "chmod u-s /usr/sbin/groupadd /usr/sbin/usermod /usr/bin/chmod && exec /init"