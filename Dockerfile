FROM alpine:latest AS builder

ARG VERSION
ARG TARGETPLATFORM

WORKDIR /tmp

COPY v2ray.sh /tmp/v2ray.sh

RUN set -ex && apk add openssl \
    && mkdir -p /etc/v2ray /usr/local/share/v2ray \
    && . /tmp/v2ray.sh "$TARGETPLATFORM" "$VERSION"


FROM alpine:latest

ENV V2RAY_LOCATION_ASSET /usr/local/share/v2ray

LABEL org.opencontainers.image.authors "nekohasekai <contact-git@sekai.icu>"
LABEL org.opencontainers.image.url https://github.com/SagerNet/docker-v2ray-core
LABEL org.opencontainers.image.documentation https://github.com/SagerNet/docker-v2ray-core/blob/main/README.md
LABEL org.opencontainers.image.source https://github.com/SagerNet/docker-v2ray-core
LABEL org.opencontainers.image.vendor "SagerNet"
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.title v2ray-core
LABEL org.opencontainers.image.description "Container for the platform for building proxies to bypass network restrictions (for SagerNet :)"

RUN set -ex && mkdir -p /etc/v2ray /usr/local/share/v2ray

COPY --from=builder /usr/bin/v2ray /usr/bin/v2ray
COPY --from=builder /usr/local/share/v2ray/geoip.dat /usr/local/share/v2ray/geoip.dat
COPY --from=builder /usr/local/share/v2ray/geosite.dat /usr/local/share/v2ray/geosite.dat

VOLUME ["/etc/v2ray"]

WORKDIR /etc/v2ray

CMD ["/usr/bin/v2ray", "run", "-c", "/etc/v2ray/config.json"]
