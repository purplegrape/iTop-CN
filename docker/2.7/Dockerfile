# syntax=docker/dockerfile:1
FROM docker.io/library/ubuntu:20.04 AS stage
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends wget unzip tar gzip
RUN wget --no-check-certificate https://sourceforge.net/projects/itop/files/itop/2.7.13/iTop-2.7.13-18098.zip/download -O /opt/iTop-2.7.zip
RUN unzip -q -d /usr/src /iTop-2.7.zip
RUN mv /usr/src/web /usr/src/itop; chown -R root:root /usr/src/itop

FROM docker.io/library/ubuntu:20.04
LABEL org.opencontainers.image.title=iTop \
      org.opencontainers.image.version=2.7 \
      org.opencontainers.image.description="iTop-2.7 & ubuntu-20.04 & apache-2.4 & php-7.4" \
      org.opencontainers.image.authors="purplegrape4@gmail.com"

RUN DEBIAN_FRONTEND=noninteractive apt update ;\
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends apache2 libapache2-mod-php7.4 php7.4-opcache php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-mysql php7.4-ldap php7.4-xml php7.4-soap php7.4-zip php-apcu graphviz mysql-client curl rsync tzdata && \
    DEBIAN_FRONTEND=noninteractive apt autoclean && \
    rm -rf /var/lib/apt /usr/share/perl /var/www/html

RUN unlink /etc/apache2/conf-enabled/other-vhosts-access-log.conf && \
    sed -i '/ErrorLog/d' /etc/apache2/sites-enabled/000-default.conf && \
    sed -i '/CustomLog/d' /etc/apache2/sites-enabled/000-default.conf  && \
    sed -i '/AllowOverride/s/None/All/g' /etc/apache2/apache2.conf && \
    sed -i '/ErrorLog/d' /etc/apache2/apache2.conf && \
    echo "ServerTokens Prod\nServerSignature off" >> /etc/apache2/apache2.conf && \
    echo "ErrorLog /proc/self/fd/2" >> /etc/apache2/apache2.conf && \
    echo "CustomLog /proc/self/fd/1 combined" >> /etc/apache2/apache2.conf

COPY --from=stage /usr/src/itop /usr/src/itop
ADD --chmod=755 entrypoint.sh /

VOLUME [ "/data" ]
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80/tcp

HEALTHCHECK --interval=30s CMD curl -sf http://127.0.0.1/images/back.png || exit 1
