# Instalar y usar docker

## Using Dockerfile
sudo docker buildx build -t _tagName_ _PathToDockerFile_
sudo docker run --rm -it _tagName_

## Using image (not tested with other dockerhub user)

sudo docker image pull mmazzanti/newgem5

# Using se.py

./build/X86/gem5.opt configs/example/se.py --cmd=IBM-gem5-tutorial/daxpy -n3  --cpu-type=X86TimingSimpleCPU --l1d_size=64kB --l1i_size=16kB --l2cache --l2_size=256kB --caches

- Problem: First thread dont work.

# Files

- Dockerfile self explanatory.
- tests/Makefile is for the m5threads/tests (automatically mv with Dockerfile)
- Makefile is for compiling the daxpy binary (also automatically with Dockerfile)
- daxpy.cpp is the implementation using pthread.
- cache.py  and two_level.py are the tutorial scripts for part1 of the learning
course of gem5.


# Compile wiht m5Threads

g++-4.8  -c -o _file_.o _file_.cpp
g++-4.8  -static -o _file_  _file_.o  path/m5threads/pthread.o




