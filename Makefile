REPO := manslaughter/docker-tor-privoxy-alpine
TAG := $(shell cat VERSION)
PLATFORMS := linux/amd64,linux/arm64,linux/ppc64le,linux/arm/v7

TOR_VERSION=0.4.4.6

.PHONY: build push test

all: build

build:
	@docker buildx \
		build -t "$(REPO):$(TAG)" \
		--build-arg="TOR_VERSION=$(TOR_VERSION)" \
		--build-arg="VERSION=$(VERSION)" \
		--load \
		--platform="linux/amd64" .

push:
	@docker buildx \
		build -t "$(REPO):$(TAG)" \
		--push \
		--build-arg="TOR_VERSION=$(TOR_VERSION)" \
		--build-arg="VERSION=$(VERSION)" \
		--platform="$(PLATFORMS)" .

test: build
	@echo "Run temporary tor privoxy"
	@docker run -d --name temp-privoxy -p 8118:8118 $(REPO):$(TAG)
	@echo "Sleep 30s"
	@sleep 30
	@echo "Check if tor privoxy works"
	@curl --proxy localhost:8118 --silent https://check.torproject.org/ | grep -qm 1 "Congratulations"
	@docker rm -f temp-privoxy
