FROM ubuntu:bionic
LABEL maintainer="marcos@scriven.org"

RUN apt-get update && apt-get install -y wget vim build-essential git python2.7 iasl nasm subversion libwww-perl uuid-dev dos2unix
RUN git clone https://github.com/tianocore/edk2.git
COPY bin/compile-qvmf.sh bin/prepare-patch.sh /