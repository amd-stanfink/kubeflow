#!/bin/bash

getent group $RENDER_GROUP_ID || groupadd --gid $RENDER_GROUP_ID render_host

usermod -aG $RENDER_GROUP_ID $NB_USER

exec newgrp $(getent group $RENDER_GROUP_ID | cut -d':' -f 1)

chmod u-s /usr/sbin/groupadd /usr/sbin/usermod /usr/bin/chmod

exec /init
