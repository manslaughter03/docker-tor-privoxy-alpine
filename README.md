# Docker tor-privoxy-alpine image for multi architecture


## Get started

```
docker run -d -p 8118:8118 -p 9050:9050 manslaughter/tor-privoxy-alpine:latest
curl --proxy localhost:8118 https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs
```

## Local build

Requirements:
* docker
* [docker buildx](https://docs.docker.com/buildx/working-with-buildx/)

```sh
make build
```

## Local test

```sh
make test
```

Fork of https://github.com/rdsubhas/docker-tor-privoxy-alpine
