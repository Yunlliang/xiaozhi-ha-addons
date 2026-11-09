# Full upstream Java API + Vue web UI image, no stub implementation.
FROM ghcr.io/xinnan-tech/xiaozhi-esp32-server:web_latest
RUN apk add --no-cache jq
COPY run.sh /ha-run.sh
RUN chmod +x /ha-run.sh
CMD ["/ha-run.sh"]
