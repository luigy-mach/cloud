FROM ubuntu:16.04

MAINTAINER Luigy Machaca <luigy.mach.arc@gmail.com>

WORKDIR /root

# Update and Upgrade

RUN apt-get -y update 
RUN apt-get -y upgrade 


# Install openssh-server, openjdk and wget


RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y --no-install-recommends openjdk-8-jdk #ok

#RUN add-apt-repository ppa:openjdk-r/ppa 
#RUN apt-get install -y apt-utils
#RUN apt-get install -y --no-install-recommends apt-utils 

RUN apt-get install -y --no-install-recommends git 
RUN apt-get install -y --no-install-recommends g++ 
RUN apt-get install -y --no-install-recommends vim 
RUN apt-get install -y --no-install-recommends net-tools
RUN apt-get install -y --no-install-recommends iputils-ping

RUN apt-get install -y --no-install-recommends python-software-properties
RUN apt-get install -y --no-install-recommends scala
RUN apt-get install -y --no-install-recommends openssh-client
RUN apt-get install -y --no-install-recommends curl

RUN apt-get install -y --no-install-recommends unzip
