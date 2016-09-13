FROM debian:jessie
MAINTAINER Jens Erat <email@jenserat.de>

VOLUME /srv
EXPOSE 137 138 139 445

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get update && \
	apt-get install --no-install-recommends -y samba && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY smb.conf /etc/samba/smb.conf

# Pregenerate password database to prevent warning messages on container startup
RUN /usr/sbin/smbd && sleep 10 && smbcontrol smbd shutdown

ENTRYPOINT [ -z ${TERM} ] && echo 'Please attach a pseudo-tty (`docker run -t jenserat/samba-publicshare`)' || /usr/sbin/smbd -FSD -d1 --option=workgroup=${workgroup:-workgroup}
