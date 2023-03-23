sudo g++-4.8 -c -o daxpy.o daxpy.cpp
sudo g++-4.8 -static -o daxpy daxpy.o ../m5threads/pthread.o

