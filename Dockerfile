FROM ubuntu:20.04
LABEL maintainer="lucpn@trobz.com"

# Metadata
ARG PW=odoo
ARG USER=odoo
ARG OE_HOME=/${USER}
ARG UID=1000
ARG GID=1000
ENV DEBIAN_FRONTEND=noninteractive 

##
# APT BOOTSTRAP
# - software-properties-common: for add-apt-repository
# - apt-transport-https: to support accessing repos via https
# - curl: to retrieve pgp keys
##
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends lsb-release software-properties-common \
  apt-transport-https curl gnupg-agent dirmngr \
  && apt-get clean all
# && apt-get install -y python3-pip python3-dev \
# && cd /usr/local/bin \
# && ln -s /usr/bin/python3 python \
# && pip3 install --upgrade pip \
# && pip3 install -U setuptools


##
# APT PACKAGES
##

ADD config/apt-requirements.txt /

# https://docs.docker.com/engine/reference/builder/
# advices NOT to use
# ENV DEBIAN_FRONTEND noninteractive
# but to set it inline instead:
RUN apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $(grep -v '^#' apt-requirements.txt)

##
# PYTHON3 DEFAULT
##

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
  update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Generate locale
RUN locale-gen en_US.UTF-8

# Set locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

##
# PIP PACKAGES
##

ADD config/pip-requirements.txt /

RUN pip3 install --no-cache-dir -r pip-requirements.txt

##
# NPM
##
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs npm
# RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g less && npm cache clean --force


# install ssh service
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server nano sudo git curl
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# create user for ssh and grant sudo for this user
# Using unencrypted password/ specifying password
RUN adduser --system --quiet --shell=/bin/bash --uid=${UID} --home=$OE_HOME --gecos 'ODOO' --group ${USER} \
  && echo "${USER}:${PW}" | \
  chpasswd && adduser ${USER} sudo && usermod -s /bin/bash ${USER}

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# # create odoo folder
# WORKDIR /home/odoo


# copy and run servivecs
RUN mkdir /scripts
COPY /services/ /scripts
WORKDIR /scripts
RUN chmod +x 01_ssh.sh
ENTRYPOINT ./01_ssh.sh

# EXPOSE 9000
# EXPOSE 22