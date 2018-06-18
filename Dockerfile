FROM ubuntu:16.04

MAINTAINER Luigy Machaca <luigy.mach.arc@gmail.com>

WORKDIR /root

# Install openssh-server, openjdk and wget

RUN apt-get -y update 
RUN apt-get -y upgrade 

#RUN add-apt-repository ppa:openjdk-r/ppa 
#RUN apt-get install -y apt-utils
#RUN apt-get install -y --no-install-recommends apt-utils 



