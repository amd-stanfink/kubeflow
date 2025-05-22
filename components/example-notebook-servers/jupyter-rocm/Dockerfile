#
# NOTE: Use the Makefiles to build this image correctly.
#

ARG BASE_IMG=<jupyter>
FROM $BASE_IMG

USER root

RUN usermod -a -G video $NB_USER
RUN chmod u+s /usr/bin/chgrp

COPY entrypoint.sh /tmp
RUN chmod 777 /tmp/entrypoint.sh

RUN export DEBIAN_FRONTEND=noninteractive \
 && wget https://repo.radeon.com/amdgpu-install/6.4/ubuntu/jammy/amdgpu-install_6.4.60400-1_all.deb \
 && apt update -y \
 && apt install -y ./amdgpu-install_6.4.60400-1_all.deb \
 && apt update -y \
 && apt install -y python3-setuptools python3-wheel \
       rocm --no-install-recommends \
       "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)" --no-install-recommends \
       amdgpu-dkms --no-install-recommends

USER $NB_UID

# install - requirements.txt
COPY --chown=${NB_USER}:${NB_GID} requirements.txt /tmp
RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
 && rm -f /tmp/requirements.txt

ENTRYPOINT ["/tmp/entrypoint.sh"]
