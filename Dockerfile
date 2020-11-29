FROM alpine:latest

ARG VERSION
ARG TOR_VERSION=0.4.4.6
EXPOSE 8118 9050

# Add tor group & user
RUN addgroup -S tor && adduser -S tor -G tor

# Update and upgrade apk package
# Install privoxy, runit & tini
RUN apk update \
    && apk upgrade \
    && apk add privoxy runit tini \
    && rm -rf /var/cache/apk/*

# Install tor
RUN build_pkgs=" \
	openssl-dev \
	zlib-dev \
	libevent-dev \
	gnupg \
	build-base \
	" \
  && runtime_pkgs=" \
	openssl \
	zlib \
	libevent \
	" \
  && apk add --no-cache --virtual builddeps ${build_pkgs} \
  && apk add --no-cache ${runtime_pkgs} \
  && cd /tmp \
  && wget https://dist.torproject.org/tor-$TOR_VERSION.tar.gz \
  && wget https://dist.torproject.org/tor-$TOR_VERSION.tar.gz.asc \
  && gpg --keyserver pool.sks-keyservers.net --recv-keys 0x9E92B601 \
  && gpg --verify tor-$TOR_VERSION.tar.gz.asc \
  && tar xzf tor-$TOR_VERSION.tar.gz \
  && cd /tmp/tor-$TOR_VERSION \
  && ./configure \
  && make \
  && make install \
  && cd \
  && rm -rf /tmp/* \
  && apk del builddeps \
  && rm -rf /var/cache/apk/*

# Copy services
COPY service /etc/service/

RUN mkdir /etc/service/tor/supervise /etc/service/privoxy/supervise \
  && chown -R tor /etc/service/tor/supervise /etc/service/privoxy/supervise

# Switch to tor user
USER tor

ENTRYPOINT ["tini", "--"]
CMD ["runsvdir", "/etc/service"]
