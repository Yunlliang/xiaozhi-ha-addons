FROM ghcr.io/xinnan-tech/xiaozhi-esp32-server:web_latest
ARG BUILD_VERSION=0.1.1
ARG BUILD_ARCH=amd64
LABEL io.hass.version="${BUILD_VERSION}" io.hass.type="app" io.hass.arch="${BUILD_ARCH}"
RUN apk add --no-cache jq
COPY run.sh /ha-run.sh
RUN chmod +x /ha-run.sh
CMD ["/ha-run.sh"]
