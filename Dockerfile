FROM php:fpm-alpine
MAINTAINER 3mpr <florian.indot@gmail.com> 

ENV DUMB_INIT_VERSION 1.2.0

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 \
 && chmod +x /usr/local/bin/dumb-init

COPY ["openssl.cnf", "/"]

RUN set -ex \
 && apk add --update --no-cache openssl nginx rsync \
 && mkdir -p /run/secrets/ \
 && openssl req -new -newkey rsa:2048 -sha1 -days 3650 -nodes -x509 -keyout /run/secrets/cert.key -out /run/secrets/cert.crt -config /openssl.cnf \
 && touch /var/log/nginx/bots.access.log && chown nginx:nginx /var/log/nginx/bots.access.log \
 && ln -sf /dev/stdout /var/log/nginx/bots.access.log \
 && rm /openssl.cnf \
 && apk del openssl

COPY [".", "/etc/nginx/"]

RUN set -ex \
 && rsync -r /etc/nginx /tmp

COPY ["entrypoint.sh", "/"]

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]