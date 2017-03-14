FROM lsiobase/xenial
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
ARG LIBICONV_VERSION="1.15"

# build packages as variable
ARG BUILD_PACKAGES="\
	file \
	g++ \
	gcc \
	libtool\
	make"

# install build packages
RUN \
 apt-get update && \
 apt-get install -y \
	${BUILD_PACKAGES} && \

# install runtime packages
 apt-get install -y \
	dbus \
	iproute2 \
	iputils-ping \
	libc-ares2 \
	libcurl3 \
	libxml2 \
	python && \

# compile gnu libiconv
 mkdir -p \
	/tmp/libiconv-src && \
 curl -o \
 /tmp/libiconv.tar.gz -L \
	"https://ftp.gnu.org/pub/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz" && \
 tar xf \
 /tmp/libiconv.tar.gz -C \
	/tmp/libiconv-src --strip-components=1 && \
 cd /tmp/libiconv-src && \
 ./configure \
	--prefix=/usr/local && \
 make && \
 make install && \

# uninstall build packages
 apt-get purge -y --auto-remove \
	${BUILD_PACKAGES} && \

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
