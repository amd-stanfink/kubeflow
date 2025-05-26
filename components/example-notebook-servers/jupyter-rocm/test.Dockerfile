FROM ubuntu:22.04

ENV NB_USER jovyan
ENV NB_UID 1000
ENV NB_GID 0
ENV NB_PREFIX /
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash
ENV USERS_GID 100
ENV HOME_TMP /tmp_home/$NB_USER
SHELL ["/bin/bash", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get -yq update \
 && apt-get -yq install --no-install-recommends \
    apt-transport-https \
    bash \
    bzip2 \
    ca-certificates \
    curl \
    git \
    gnupg \
    gnupg2 \
    locales \
    lsb-release \
    nano \
    software-properties-common \
    tzdata \
    unzip \
    vim \
    wget \
    xz-utils \
    zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -M -N \
    --shell /bin/bash \
    --home ${HOME} \
    --uid ${NB_UID} \
    --gid ${NB_GID} \
    --groups ${USERS_GID} \
    ${NB_USER} \
 && mkdir -pv ${HOME} \
 && mkdir -pv ${HOME_TMP} \
 && chmod 2775 ${HOME} \
 && chmod 2775 ${HOME_TMP} \
 && chown -R ${NB_USER}:${USERS_GID} ${HOME} \
 && chown -R ${NB_USER}:${USERS_GID} ${HOME_TMP} \
 && chown -R ${NB_USER}:${NB_GID} /usr/local/bin

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

USER root

RUN usermod -a -G video $NB_USER
RUN chmod u+s /usr/bin/chgrp /usr/bin/chmod

COPY test.entrypoint.sh /tmp
RUN chmod 777 /tmp/test.entrypoint.sh

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

ENTRYPOINT ["/tmp/test.entrypoint.sh"]
