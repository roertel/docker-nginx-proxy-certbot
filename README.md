# docker-nginx-proxy-certbot
Private repository

docker image for an [nginx](//nginx.com/) HTTP & IMAP/SMTP proxy server with TLS  certificates using the free [letsencrypt](//letsencrypt.org/) certificate authority, using the [*certbot*](//certbot.eff.org/) client.

# Usage
Create a configuration directory or volume and mount it on /etc/nginx/config. The structure of the directory is as follows

Directory | Content
---|---
`conf.d`   | top level nginx configuration directives
`events.d` | events configuration directives
`http.d`   | http configuration directives
`mail.d`   | mail configuration directivese

Files must end in `.conf`; all other extensions will be ignored. Files are processed in shell order. Prefix with 10-, 20-, etc if you require an order

## startup
```
docker run [-it] [--name nginx-proxy] --publish 80:80 --publish 443:443 \
  --volume nginx-certs:/etc/letsencrypt --volume nginx-config:/etc/nginx/config:ro \
  [--env NGINX_HOST=example.com] [--env LETSENCRYPT_EMAIL=user@example.com] \
  --env CERTBOT_ARGS="--no-eff-email --keep-until-expiring --redirect --must-staple --hsts --noninteractive -d *.example.com --test-cert" \
  nginx-proxy-certbot  sh
```

## Renew
`docker exec [-ti] CONTAINER certbot renew [ARG...]`

# Environment
In addition to the core nginx-alpline image options, the following environment variables are interpreted

Variable | Description
---|---
CERTBOT_EMAIL | email address to register with your certificate
CERTBOT_ARGS | additional certbot arguments. `authenticator` `installer` and `agree-tos` are already included
