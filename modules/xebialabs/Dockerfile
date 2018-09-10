# Dockerfile for xebialabsunsupport/xl-release:8.2
# Build with:
# docker build -t xebialabsunsupported/xl-release:8.2 .
# Push with:
# docker push xebialabsunsupported/xl-release:8.2
FROM xebialabs/xl-release:8.2

USER root
COPY fix-hostname.sh /opt/xebialabs/xl-release-server/bin/
RUN chmod +x /opt/xebialabs/xl-release-server/bin/fix-hostname.sh

ENTRYPOINT ["/opt/xebialabs/tini", "/opt/xebialabs/xl-release-server/bin/fix-hostname.sh"]
