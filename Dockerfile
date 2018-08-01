FROM ubuntu:bionic
LABEL maintainer="marcos@scriven.org"

RUN apt-get update && apt-get install -y wget vim build-essential git python2.7 iasl nasm subversion libwww-perl uuid-dev
RUN git clone https://github.com/tianocore/edk2.git
RUN cd /edk2; mkdir -p bin && ln -sf /usr/bin/python2.7 bin/python 
RUN cd /edk2; export PATH="/edk2/bin:$PATH"; make -C BaseTools
