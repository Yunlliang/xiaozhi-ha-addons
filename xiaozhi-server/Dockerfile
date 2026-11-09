# Uses the upstream full Server application and all its bundled dependencies.
# Pin to a tested upstream digest before production deployment.
FROM ghcr.io/xinnan-tech/xiaozhi-esp32-server:server_latest
COPY run.sh /ha-run.sh
RUN chmod +x /ha-run.sh
CMD ["/ha-run.sh"]
