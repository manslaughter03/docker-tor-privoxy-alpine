# Fork tor-privoxy-alpine for armv7 device

## TODO:

- Create user instead using root user

```
docker run -d -p 8118:8118 -p 9050:9050 manslaughter/tor-privoxy-arm32v7-alpine:tagname
curl --proxy localhost:8118 https://www.google.com
```

Fork of https://github.com/rdsubhas/docker-tor-privoxy-alpine
