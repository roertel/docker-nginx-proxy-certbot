FROM nginx:stable-alpine
LABEL maintainer="Ryan Oertel <ryan.oertel@gmail.com>"

VOLUME /etc/letsencrypt
EXPOSE 25/tcp
EXPOSE 80/tcp
EXPOSE 143/tcp
EXPOSE 443/tcp
EXPOSE 587/tcp
EXPOSE 993/tcp

RUN apk add --update-cache --quiet certbot-nginx && \
   rm -rf /var/lib/apk/db /var/cache/apk/*

# Copy in our certbot entrypoint script
COPY ./startup/ /docker-entrypoint.d/
RUN chmod -f +x /docker-entrypoint.d/*.sh

# Copy in our helper scripts
COPY ./scripts/ /usr/local/bin/
RUN chmod -f +x /usr/local/bin/*

# Copy in default nginx configuration
COPY ./configs/nginx.conf /etc/nginx/
RUN mkdir -p \
   /etc/nginx/conf.d/config.d \
   /etc/nginx/conf.d/events.d \
   /etc/nginx/conf.d/http.d   \
   /etc/nginx/conf.d/mail.d

# Use the same Nginx entrypoint, which will call our certbot script
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
