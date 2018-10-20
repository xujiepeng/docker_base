FROM centos/python-36-centos7

ENV DOCKER_HOME=/root
ENV DOCKER_PROJECT=/root/project

WORKDIR $DOCKER_PROJECT

USER root
COPY requirements.txt ./
COPY ./ ./
RUN /opt/app-root/bin/pip install --no-cache-dir -r requirements.txt

RUN yum -y install epel-release
RUN yum install nginx

CMD ["nginx", "-g", "daemon off;"]

