FROM xebialabs/xl-release:8.2 as build

USER root
COPY fix-hostname.sh /opt/xebialabs/xl-release-server/bin/
RUN chmod +x /opt/xebialabs/xl-release-server/bin/fix-hostname.sh

ENTRYPOINT ["/opt/xebialabs/tini", "/opt/xebialabs/xl-release-server/bin/fix-hostname.sh"]
