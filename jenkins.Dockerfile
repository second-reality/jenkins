FROM debian:bullseye

# install docker
RUN apt update && apt install -y apt-transport-https ca-certificates \
                    curl gnupg2 software-properties-common &&\
 curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - &&\
 apt-key fingerprint 0EBFCD88 &&\
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" &&\
 apt update && apt install -y docker-ce docker-compose

RUN apt update && apt install -y openjdk-17-jre
RUN apt update && apt install -y wget
RUN apt update && apt install -y git
RUN apt update && apt install -y sshpass rsync
# 'free' command + awk
RUN apt update && apt install -y procps gawk

RUN mkdir /jenkins_home
RUN cd / && wget http://mirrors.jenkins.io/war-stable/2.375.2/jenkins.war

ENV JENKINS_HOME /jenkins_home

EXPOSE 8080
# java web start to connect windows host
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/jenkins.war", "--httpPort=8080"]
