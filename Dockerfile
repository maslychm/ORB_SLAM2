FROM nvidia/opengl:base-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    ca-certificates wget unzip cmake git build-essential pkg-config \
    libjpeg-dev libtiff5-dev libpng-dev \
    libtbb-dev libavcodec-dev libavformat-dev libswscale-dev \
    libxvidcore-dev libx264-dev libgtk2.0-dev libatlas-base-dev \
    libeigen3-dev libblas-dev liblapack-dev libglew-dev gfortran \
    python2.7-dev python3-dev python-numpy python3-numpy

RUN mkdir -p /build/opencv && cd /build/opencv
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/refs/heads/3.4.zip \
    && unzip opencv.zip \
    && cd opencv-3.4/ \
    && mkdir build \
    && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_CUDA=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF .. \
    && make -j   2>&1 | tee -a  make.log \
    && make install 2>&1 | tee -a  make_install.log

# install Pangolin
RUN mkdir -p /build/Pangolin && cd /build/Pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin \
    && cd Pangolin \
    && git checkout e1c79a678f1b68e4d19852a108201caaf7b31307 \
    && mkdir build \
    && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
    && make -j \
    && make install

# install ORB_SLAM2
WORKDIR /ORB_SLAM2
COPY . .
RUN ./build.sh

#RUN git clone https://github.com/maslychm/ORB_SLAM2 \
#	&& cd ORB_SLAM2 \
#	&& chmod +x build.sh \
#	&& ./build.sh

CMD [ "/bin/bash" ]