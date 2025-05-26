#!/bin/bash

chgrp video /dev/dri/renderD*

chmod u-s /usr/bin/chgrp /usr/bin/chmod

exec /init
