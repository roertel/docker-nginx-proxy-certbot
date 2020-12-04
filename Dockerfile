FROM nginx:stable-alpine
LABEL maintainer="Ryan Oertel <ryan.oertel@gmail.com>"

VOLUME /etc/letsencrypt
EXPOSE 25
EXPOSE 80
EXPOSE 143
EXPOSE 443
EXPOSE 587
EXPOSE 993

RUN apk add --update-cache --quiet certbot-nginx && \
   rm -rf /var/lib/apk/db /var/cache/apk/*

COPY ./startup/ /docker-entrypoint.d/
RUN chmod -f +x /docker-entrypoint.d/*.sh

COPY ./scripts/ /usr/local/bin/
RUN chmod -f +x /usr/local/bin/*

# Copy in default nginx configuration, derived from the base image
COPY ./configs/nginx.conf /etc/nginx/
RUN mkdir -p /etc/nginx/config/{config,events,http,mail}.d

#ENTRYPOINT []
#CMD ["/bin/bash", "/scripts/entrypoint.sh"]
