FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG EMBYSTAT_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV HOME="/config"

RUN \
  apt-get update && \
  apt-get install -y \
    libicu70 \
    libssl3 \
    unzip && \
  echo "**** install embystat ****" && \
  mkdir -p \
    /opt/embystat && \
  if [ -z ${EMBYSTAT_RELEASE+x} ]; then \
    EMBYSTAT_RELEASE=$(curl -sX GET "https://api.github.com/repos/mregni/EmbyStat/releases" \
      | jq -r 'first(.[] | .tag_name)'); \
  fi && \
  curl -o \
    /tmp/embystat.zip -L \
    "https://github.com/mregni/EmbyStat/releases/download/${EMBYSTAT_RELEASE}/EmbyStat-ubuntu-x64-v${EMBYSTAT_RELEASE}.zip" && \
  unzip /tmp/embystat.zip -d \
    /opt/embystat/ 2> /dev/null || true && \
  chmod +x /opt/embystat/EmbyStat && \
  echo "**** clean up ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 6555
