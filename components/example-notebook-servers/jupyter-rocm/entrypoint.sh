#!/bin/bash

getent group $RENDER_GROUP_ID || groupadd --gid $RENDER_GROUP_ID render_host

usermod -aG render_host $NB_USER

chmod u-s /usr/sbin/groupadd /usr/sbin/usermod /usr/bin/chmod

exec /init
