ARG DS_VER

# ENV Deepstream_VER=$DS_VER
# ENV CD_VER=$DS_VER=$DS_VER

FROM nvcr.io/nvidia/deepstream:$DS_VER-devel as parserbuilder
ARG DS_VER
ARG CUDA_VER

ENV Deepstream_VER=$DS_VER
ENV CD_VER=$CUDA_VER

# Update GPG public keys (https://github.com/NVIDIA/nvidia-docker/issues/1631)
RUN apt-key del 7fa2af80 && \
    apt install wget && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    rm cuda-keyring_1.0-1_all.deb && \
    apt-get clean && apt-get autoremove -y

# Install needed libraries
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    # Dependencies for LightTrack
    libeigen3-dev \
    cmake && \
    apt-get clean && apt-get autoremove -y

# make the shared folder
RUN mkdir -p /cv_parser_lib


# Remove the original Makefile and nvdsparsebbox_Yolo.cpp.cpp
WORKDIR /opt/nvidia/deepstream/deepstream-$Deepstream_VER/sources/objectDetector_Yolo/nvdsinfer_custom_impl_Yolo 
RUN rm Makefile && \
    rm nvdsparsebbox_Yolo.cpp

# Copy all the goodies in
COPY ./cv/* /opt/nvidia/deepstream/deepstream-$Deepstream_VER/sources/objectDetector_Yolo/nvdsinfer_custom_impl_Yolo/


# Build the custom parser .so file
RUN CUDA_VER=$CD_VER make && \
   rm Makefile && \
   rm *.cpp && \
   cp /opt/nvidia/deepstream/deepstream-$Deepstream_VER/sources/objectDetector_Yolo/nvdsinfer_custom_impl_Yolo/libnvdsinfer_custom_impl_Yolo.so /cv_parser_lib/
