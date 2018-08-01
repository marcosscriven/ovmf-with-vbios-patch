FROM ubuntu:bionic
LABEL maintainer="marcos@scriven.org"

# Install all the deps and code
RUN apt-get update && apt-get install -y wget vim build-essential git python2.7 iasl nasm subversion libwww-perl uuid-dev
RUN git clone https://github.com/tianocore/edk2.git

# Set up env
ENV PATH="/edk2/bin:${PATH}"
ENV EDK_TOOLS_PATH="/edk2/BaseTools"
ENV SRC="/edk2"
WORKDIR ${SRC}

# Build
RUN mkdir -p bin && ln -sf /usr/bin/python2.7 bin/python 
RUN make -C BaseTools
RUN . edksetup.sh BaseTools && ./BaseTools/BinWrappers/PosixLike/build -t GCC5 -a X64 -p OvmfPkg/OvmfPkgX64.dsc -n $(nproc) -b RELEASE -D FD_SIZE_2MB
