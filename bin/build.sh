#! /bin/bash

docker build -t qvmf-vbios-patch .       
docker run qvmf-vbios-patch /compile-qvmf.sh