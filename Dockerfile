FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
ENV KERNEL_SOURCE_VERSION 4.9

WORKDIR /root

RUN apt-get update && apt-get install -y debootstrap build-essential \
  fakeroot linux-source-$KERNEL_SOURCE_VERSION bc kmod cpio flex cpio libncurses5-dev libelf-dev libssl-dev && \
  tar xvf /usr/src/linux-source-$KERNEL_SOURCE_VERSION.tar.*

ADD config/kernel-config /root/linux-source-$KERNEL_SOURCE_VERSION/.config

RUN make -C linux-source-$KERNEL_SOURCE_VERSION silentoldconfig && \
  make -C linux-source-$KERNEL_SOURCE_VERSION clean && \
  make -C linux-source-$KERNEL_SOURCE_VERSION -j $(nproc) deb-pkg

VOLUME [ "/output", "/rootfs", "/script", "/config" ]

ADD script /script
ADD config /config

CMD [ "/bin/bash", "/script/image.sh" ]