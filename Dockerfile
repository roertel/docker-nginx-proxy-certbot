FROM nginx-alpine
LABEL maintainer="Ryan Oertel <ryan.oertel@gmail.com>"

VOLUME /etc/letsencrypt
EXPOSE 25
EXPOSE 80
EXPOSE 143
EXPOSE 443
EXPOSE 587
EXPOSE 993

RUN apk add -Uq certbot-nginx && rm -rf /var/lib/apk/db /var/cache/apk/*

#COPY ./scripts/ /scripts
#RUN chmod +x /scripts/*.sh

# Copy in default nginx configuration (which just forwards ACME requests to
# certbot, or redirects to HTTPS, but has no HTTPS configurations by default).
RUN rm -f /etc/nginx/conf.d/*
COPY nginx_conf.d/ /etc/nginx/conf.d/

ENTRYPOINT []
CMD ["/bin/bash", "/scripts/entrypoint.sh"]
