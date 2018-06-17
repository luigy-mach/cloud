FROM ubuntu:16.04

MAINTAINER Luigy Machaca <luigy.mach.arc@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server
