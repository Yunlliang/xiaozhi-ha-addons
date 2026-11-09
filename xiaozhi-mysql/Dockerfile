FROM mysql:8.0
ARG BUILD_VERSION=0.1.0
ARG BUILD_ARCH=amd64
LABEL io.hass.version="${BUILD_VERSION}" io.hass.type="app" io.hass.arch="${BUILD_ARCH}"
RUN microdnf install -y jq && microdnf clean all
COPY run.sh /ha-run.sh
RUN chmod 755 /ha-run.sh
ENTRYPOINT ["/ha-run.sh"]
