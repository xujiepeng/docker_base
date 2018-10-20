FROM centos/python-36-centos7

ENV DOCKER_HOME=/root
ENV DOCKER_PROJECT=/root/project

WORKDIR $DOCKER_PROJECT

USER root
COPY requirements.txt ./
COPY ./ ./
RUN /opt/app-root/bin/pip install --no-cache-dir -r requirements.txt

ADD nginx.repo /etc/yum.repos.d
RUN yum install nginx -y
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN useradd -s /sbin/nologin -M www
#EXPOSE 80
#CMD ["nginx"]
#CMD ["nginx", "-g", "daemon off;"]

