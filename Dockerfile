FROM alpine:3.8

RUN apk add --no-cache iproute2 autoconf automake build-base gcc libpcap-dev libsodium-dev libev-dev linux-headers bsd-compat-headers musl-dev patch

# Add the mlvpn launch script
#ADD mlvpn.sh /usr/sbin/mlvpn.sh

# MLVPN new reorder
WORKDIR /tmp
ADD https://github.com/markfoodyburton/MLVPN/archive/new-reorder.zip /tmp/new-reorder.zip
RUN unzip /tmp/new-reorder.zip
WORKDIR /tmp/MLVPN-new-reorder
COPY patches /tmp/MLVPN-new-reorder/patches
RUN for i in patches/*.patch; do patch -p1 < $i; done
RUN ./autogen.sh && ./configure --sysconfdir=/etc
RUN make && make install

#CMD /usr/sbin/mlvpn.sh
