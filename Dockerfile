FROM ubuntu
MAINTAINER Memiks <contact@memiks.fr>

# Download tools and prerequisites
RUN apt-get update \
  && apt-get install -y curl git unzip bzip2 build-essential gcc-multilib srecord pkg-config python libusb-1.0.0 \
  && apt-get clean all \
  && rm -rf /var/lib/apt/lists/*

# Download and install ARM toolchain matching the SDK
RUN curl -SL https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 > /tmp/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 && \
tar xvjf /tmp/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 -C /usr/local/ && \
rm /tmp/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2

# Download NRF5 SDK v16.0.0 and extract nRF5 SDK to /nrf5/nRF5_SDK_16.0.0
RUN curl -SL https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v16.x.x/nRF5_SDK_16.0.0_98a08e2.zip > /tmp/SDK_16.0.0.zip && \
mkdir -p /nrf5 && \
unzip -q /tmp/SDK_16.0.0.zip -d /nrf5/nRF5_SDK_16.0.0 && \
rm /tmp/SDK_16.0.0.zip

# Add micro-ecc to SDK
RUN curl -SL https://github.com/kmackay/micro-ecc/archive/v1.0.zip > /tmp/micro-ecc_v1.0.zip && \
unzip -q /tmp/micro-ecc_v1.0.zip -d /nrf5/nRF5_SDK_16.0.0/external/micro-ecc && \
mv /nrf5/nRF5_SDK_16.0.0/external/micro-ecc/micro-ecc-1.0 /nrf5/nRF5_SDK_16.0.0/external/micro-ecc/micro-ecc && \
make -C /nrf5/nRF5_SDK_16.0.0/external/micro-ecc/nrf52hf_armgcc/armgcc && \
rm /tmp/micro-ecc_v1.0.zip

# Install nRF Tools (makes it easy to build a DFU package)
RUN apt-get install -y python-pip && \
pip install nrfutil

