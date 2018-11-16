FROM alpine:3.8

LABEL maintainer="Ycarus (Yannick Chabanois) <ycarus@zugaina.org>"

ENV MLVPN /etc/mlvpn

RUN apk add --no-cache iproute2 autoconf automake build-base gcc libpcap-dev libsodium-dev libev-dev linux-headers bsd-compat-headers musl-dev patch

# MLVPN new reorder
WORKDIR /tmp
ADD https://github.com/markfoodyburton/MLVPN/archive/new-reorder.zip /tmp/new-reorder.zip
COPY patches /tmp/patches
RUN unzip /tmp/new-reorder.zip \
    && cd /tmp/MLVPN-new-reorder \
    && for i in ../patches/*.patch; do patch -p1 < $i; done \
    && ./autogen.sh \
    && ./configure --sysconfdir=/etc \
    && make \
    && make install \
    && rm -rf /tmp/MLVPN-new-reorder \
    && apk del autoconf automake build-base gcc linux-headers bsd-compat-headers patch

COPY mlvpn0.conf /etc/mlvpn/mlvpn0.conf

CMD /usr/local/bin/mlvpn --config /etc/mlvpn/mlvpn0.conf
