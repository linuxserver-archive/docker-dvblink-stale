FROM lsiobase/ubuntu:xenial
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV DVBLINK_CONFIG_DIR="/config" \
DVBLINK_COMMON_DIR="/config"

# package versions
ARG DVBLINK_DLINK="http://download.dvblogic.com/9283649d35acc98ccf4d0c2287cdee62/"



# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	dbus \
	iproute2 \
	iputils-ping && \

# install dvblink server
 mkdir -p \
	/usr/share/applications && \
 curl -o \
 /tmp/dvblink.deb -L \
	"${DVBLINK_DLINK}" && \
 dpkg -i /tmp/dvblink.deb && \

# configure dvblink
 mv /opt/DVBLink /defaults/DVBLink && \

# cleanup
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8100 39876
VOLUME /config /data
