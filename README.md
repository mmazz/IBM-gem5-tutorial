# Instalar y usar docker

## Using Dockerfile
sudo docker buildx build -t _tagName_ _PathToDockerFile_
sudo docker run --rm -it _tagName_

## Using image (not tested with other dockerhub user)

sudo docker image pull mmazzanti/newgem5


# Files

- Dockerfile self explanatory.
- tests/Makefile is for the m5threads/tests (automatically mv with Dockerfile)
- Makefile is for compiling the daxpy binary (also automatically with Dockerfile)
- daxpy.cpp is the implementation using pthread.
- cache.py  and two_level.py are the tutorial scripts for part1 of the learning
course of gem5.
