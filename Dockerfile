FROM ubuntu:16.04

RUN apt -y update
RUN apt -y upgrade
RUN apt -y install sudo vim
RUN useradd -m mmazz
RUN echo "root:espada" | chpasswd
RUN echo "mmazz:espada" | chpasswd
RUN usermod -aG sudo mmazz
RUN echo "%mmazz ALL=(ALL) ALL" >> /etc/sudoers
WORKDIR /home/mmazz
RUN apt -y install build-essential git m4 zlib1g zlib1g-dev libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev

RUN apt -y install curl wget gcc-4.8 g++-4.8
RUN apt -y install software-properties-common
#RUN apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com:80
RUN apt -y update
RUN add-apt-repository -y ppa:jblgf0/python
RUN add-apt-repository ppa:ubuntu-toolchain-r/test

RUN apt -y update

RUN apt -y install python3.7
RUN apt -y install python3.7-dev
RUN apt -y install python3.7-venv
RUN apt -y install doxygen libboost-all-dev libhdf5-serial-dev libpng-dev libelf-dev pkg-config
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.7 get-pip.py
RUN ln -s /usr/bin/python3.7 /usr/local/bin/python3

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2
RUN update-alternatives --config python
RUN ln -sf /usr/bin/python3.7-config /usr/bin/python-config

RUN apt -y install --reinstall build-essential

#RUN python get-pip.py
RUN python -m pip install black mypy pre-commit
RUN python -m pip install python-config
RUN python -m pip install scons==3.1.2
RUN apt -y install gcc-7 g++-7
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
                         --slave /usr/bin/g++ g++ /usr/bin/g++-7
RUN update-alternatives --config gcc
RUN echo PATH=$PATH:~/.local/bin
RUN apt -y update
RUN apt -y upgrade
WORKDIR /home/mmazz/
RUN git clone --depth 1 https://gem5.googlesource.com/public/gem5
WORKDIR /home/mmazz/gem5
RUN git clone https://github.com/gem5/m5threads.git
WORKDIR /home/mmazz/gem5/m5threads
RUN make
WORKDIR /home/mmazz/gem5
#RUN echo " " | echo y | scons build/X86/gem5.opt -j10
RUN scons /home/mmazz/gem5/build/X86/gem5.opt -j10
WORKDIR /home/mmazz/gem5
RUN git clone https://github.com/mmazz/IBM-gem5-tutorial.git
RUN  cp /home/mmazz/gem5/IBM-gem5-tutorial/tests/Makefile /home/mmazz/gem5/m5threads/tests
WORKDIR /home/mmazz/gem5/m5threads/tests
RUN make
WORKDIR /home/mmazz/gem5/IBM-gem5-tutorial
RUN make

WORKDIR /home/mmazz/gem5
