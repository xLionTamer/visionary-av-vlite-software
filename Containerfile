FROM docker.io/eclipse-temurin:8-jre-jammy

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        fontconfig \
        fonts-dejavu-core \
        libgtk-3-0 \
        libxi6 \
        libxext6 \
        libxrender1 \
        libxtst6 \
    && rm -rf /var/lib/apt/lists/*

ARG VLITE_JAR=VLite-3.1910.2_Software__Release-Notes/VLite-3.1910.2_Software_&_Release-Notes/VLite_5K_3_1910_2.jar

RUN useradd --create-home --uid 1000 --shell /usr/sbin/nologin vlite \
    && install --directory --owner=vlite --group=vlite /opt/vlite /var/lib/vlite
COPY --chown=vlite:vlite ${VLITE_JAR} /opt/vlite/vlite.jar

ENV HOME=/var/lib/vlite
WORKDIR /var/lib/vlite
USER vlite

ENTRYPOINT ["java", "-Duser.home=/var/lib/vlite", "-jar", "/opt/vlite/vlite.jar"]
