FROM --platform=${TARGETPLATFORM} alpine:latest
LABEL maintainer "nekohasekai <contact-git@sekai.icu>"

WORKDIR /root
ARG TARGETPLATFORM
ARG TAG
COPY v2ray.sh /root/v2ray.sh

RUN set -ex \
	&& apk add --no-cache tzdata openssl ca-certificates \
	&& mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
	&& chmod +x /root/v2ray.sh \
	&& /root/v2ray.sh "${TARGETPLATFORM}" "${TAG}"

VOLUME /etc/v2ray
CMD [ "/usr/bin/v2ray", "run", "-c", "/etc/v2ray/config.json" ]
