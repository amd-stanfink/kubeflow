#!/bin/bash

getent group render || groupadd --gid $RENDER_GROUP_ID render

usermod -aG render $NB_USER

chmod u-s /usr/sbin/groupadd /usr/sbin/usermod /usr/bin/chmod

exec /init
