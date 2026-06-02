# syntax=docker/dockerfile:1
FROM docker.io/library/ubuntu:22.04 AS stage
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y wget unzip tar gzip 
RUN wget --no-check-certificate https://sourceforge.net/projects/itop/files/itop/3.2.1/iTop-3.2.1-16429.zip/download -O /iTop-3.2.zip
RUN unzip -q -d /usr/src /iTop-3.2.zip
RUN mv /usr/src/web /usr/src/itop
RUN chown root:root /usr/src/itop ;\
    find /usr/src/itop -type f -exec chmod 644 {} \; ;\
    find /usr/src/itop -type d -exec chmod 755 {} \;

FROM docker.io/library/ubuntu:22.04
LABEL org.opencontainers.image.title=iTop \
      org.opencontainers.image.version=3.2 \
      org.opencontainers.image.description="iTop-3.2 & ubuntu-22.04 & apache-2.4 & php-8.1" \
      org.opencontainers.image.authors="purplegrape4@gmail.com"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y apache2 libapache2-mod-php8.1 php8.1-opcache php8.1-curl php8.1-gd php8.1-intl php8.1-mbstring php8.1-mysql php8.1-ldap php8.1-xml php8.1-soap php8.1-zip php-apcu graphviz mysql-client curl rsync tzdata && \
    DEBIAN_FRONTEND=noninteractive apt-get autoclean && \
    rm -rf /var/lib/apt /usr/share/perl

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
