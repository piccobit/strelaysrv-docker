# Use Alpine Linux as our base image so that we minimize the overall size our final container, and minimize the surface area of packages that could be out of date.
FROM alpine:3.8@sha256:621c2f39f8133acb8e64023a94dbdf0d5ca81896102b9e57c0dc184cadaf5528

LABEL description="Docker container for running your own Syncthing Relay Server."
LABEL maintainer="HD Stich <hd.stich.io>"

ENV STRELAYSRV_VERSION=v1.0.1
ENV STRELAYSRV_BINARY=strelaysrv-linux-amd64-${STRELAYSRV_VERSION}

RUN apk add --update libc6-compat libstdc++ \
   && apk upgrade \
   && apk add --no-cache ca-certificates

RUN addgroup -g 1000 strelaysrv \
    && adduser -D -G strelaysrv -u 1000 strelaysrv \
    && mkdir -p /etc/strelaysrv \
    && chown strelaysrv:strelaysrv /etc/strelaysrv

ADD https://github.com/syncthing/relaysrv/releases/download/${STRELAYSRV_VERSION}/${STRELAYSRV_BINARY}.tar.gz /tmp

RUN tar -xf /tmp/${STRELAYSRV_BINARY}.tar.gz -C /tmp \
    && mv /tmp/${STRELAYSRV_BINARY}/strelaysrv /bin/strelaysrv \
    && rm -rf /tmp/${STRELAYSRV_BINARY} \
    && rm -rf /tmp/${STRELAYSRV_BINARY}.tar.gz

VOLUME /etc/strelaysrv

EXPOSE 22067
EXPOSE 22070

WORKDIR /etc/strelaysrv

USER strelaysrv

CMD ["strelaysrv"]
