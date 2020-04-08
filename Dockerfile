FROM ubuntu:18.04

# install python
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip && pip3 install -U setuptools
ENTRYPOINT ["python3"]

# install Django requirements
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN chmod -R 775 /code/requirements.txt
RUN pip3 install -r requirements.txt
COPY . /code/
EXPOSE 9000
CMD exec gunicorn composeexample.wsgi:application — bind 0.0.0.0:8000 — workers 3

# install ssh service
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:THEPASSWORDYOUCREATED' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]