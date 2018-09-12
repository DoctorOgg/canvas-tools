# docker run -it -v //c/somefolder:/root ogg42/canvas-tools:0.2 /bin/bash
# docker run -it -v `pwd`:/root ogg42/canvas-tools:0.2 /bin/bash
# docker build -t ogg42/canvas-tools:0.4 .
# docker push ogg42/canvas-tools:0.4
# FROM debian:8.7
FROM ubuntu:18.04
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get -y install tzdata \
  && ln -fs /usr/share/zoneinfo/US/Pacific-New /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
  && apt-get -y install ruby-dev rubygems build-essential libncurses5-dev \
  && gem install canvas-tools \
  && apt-get install -y joe nano vim-nox
CMD
