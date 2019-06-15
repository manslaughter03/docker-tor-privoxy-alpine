FROM hypriot/rpi-alpine-scratch:edge

ARG TOR_VERSION 0.3.4.9
EXPOSE 8118 9050

RUN apk update \
    && apk upgrade \
    && apk add privoxy supervisor \
    && rm -rf /var/cache/apk/*

# Install tor
RUN build_pkgs=" \
	openssl-dev \
	zlib-dev \
	libevent-dev \
	gnupg \
	" \
  && runtime_pkgs=" \
	build-base \
	openssl \
	zlib \
	libevent \
	" \
  && apk --update add ${build_pkgs} ${runtime_pkgs} \
  && cd /tmp \
  && wget https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz \
  && wget https://www.torproject.org/dist/tor-$TOR_VERSION.tar.gz.asc \
  && gpg --keyserver pool.sks-keyservers.net --recv-keys 0x9E92B601 \
  && gpg --verify tor-$TOR_VERSION.tar.gz.asc \
  && tar xzf tor-$TOR_VERSION.tar.gz \
  && cd /tmp/tor-$TOR_VERSION \
  && ./configure \
  && make \
  && make install \
  && cd \
  && rm -rf /tmp/* \
  && apk del ${build_pkgs} \
  && rm -rf /var/cache/apk/*

COPY service /etc/service/
COPY supervisor/supervisord.conf /etc
COPY supervisor/*.svc.conf /etc/supervisor/conf.d/

CMD ["/usr/bin/supervisord"]
