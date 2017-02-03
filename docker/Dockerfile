# docker run -it -v //c/somefolder:/root ogg42/canvas-tools:0.1 /bin/bash
# docker run -it -v `pwd`:/root ogg42/canvas-tools:0.1 /bin/bash
# docker build -t ogg42/canvas-tools:0.1 .
# docker push ogg42/canvas-tools:0.1
FROM debian:8.7
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get -y install ruby-dev rubygems build-essential libncurses5-dev \
  && gem install canvas-tools \
  && apt-get install -y joe nano vim-nox
CMD
