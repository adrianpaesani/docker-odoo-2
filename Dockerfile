FROM ubuntu:18.04
LABEL maintainer="lucpn@trobz.com"

# Metadata
ARG PW=docker
ARG USER=docker
ARG UID=1000
ARG GID=1000

# install python
RUN apt-get update -y \
  && apt-get install -y lsb-release \
  && apt-get clean all \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip \
  && pip3 install -U setuptools

RUN apt-get install nano -y

# install ssh service
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# create user for ssh and grant sudo for this user
# Using unencrypted password/ specifying password
RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | \
  chpasswd && adduser ${USER} sudo && usermod -s /bin/bash ${USER}

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# # install Django requirements
WORKDIR /home/docker
COPY requirements.txt ./
RUN apt-get install libpq-dev -y
RUN chmod -R 775 requirements.txt
RUN pip3 install -r requirements.txt
# COPY . /home/docker/code/

RUN echo "cd /home/docker/code/docker-django/portfolio-project && python3 manage.py runserver 0.0.0.0:9000" >> /home/docker/.bashrc

# ENTRYPOINT ["bash"]


# copy and run servivecs
RUN mkdir /scripts
COPY /services/ /scripts/
WORKDIR /scripts
RUN chmod +x 01_ssh.sh
ENTRYPOINT ./01_ssh.sh

# EXPOSE 9000
# EXPOSE 22