FROM redis:7.4-alpine
ARG BUILD_VERSION=0.1.0
ARG BUILD_ARCH=amd64
LABEL io.hass.version="${BUILD_VERSION}" io.hass.type="app" io.hass.arch="${BUILD_ARCH}"
RUN apk add --no-cache jq
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]
