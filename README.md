# docker-nginx-proxy-certbot
Private repository

docker image for an [nginx](//nginx.com/) HTTP & IMAP/SMTP proxy server with TLS  certificates using the free [letsencrypt](//letsencrypt.org/) certificate authority, using the [*certbot*](//certbot.eff.org/) client.

# Usage
Create a configuration directory or volume and mount it on /etc/nginx/config. The structure of the directory is as follows.

Directory | Content
---|---
`conf.d`   | top level nginx configuration directives
`events.d` | events configuration directives
`http.d`   | http configuration directives
`mail.d`   | mail configuration directivese

Files must end in `.conf`; all other extensions will be ignored. Files are processed in shell order. Prefix with 10-, 20-, etc if you require an order.

## startup
```
docker run [-it] [--name nginx-proxy] --publish 80:80 --publish 443:443 \
  --volume nginx-certs:/etc/letsencrypt --volume nginx-config:/etc/nginx/config:ro \
  [--env NGINX_HOST=example.com] [--env LETSENCRYPT_EMAIL=user@example.com] \
  --env CERTBOT_ARGS="--no-eff-email --keep-until-expiring --redirect --must-staple --noninteractive -d *.example.com --test-cert" \
  nginx-proxy-certbot  sh
```

## Renew
Since cron doesn't work very well inside of containers, create the following crontab entry on the docker host.

```
$ cat /etc/cron.d/certbot

# /etc/cron.d/certbot: crontab entries for the certbot package
#
# Upstream recommends attempting renewal twice a day
#
# Eventually, this will be an opportunity to validate certificates
# haven't been revoked, etc.  Renewal will only occur if expiration
# is within 30 days.
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

0 */12 * * * docker perl -e 'sleep int(rand(43200))' && docker exec nginx-proxy certbot -q renew
```

# Environment
In addition to the core nginx-alpline image options, the following environment variables are available.

Variable | Description
---|---
CERTBOT_EMAIL | email address to register with your certificate
CERTBOT_ARGS | additional certbot arguments. `authenticator` `installer` and `agree-tos` are already included

# Additional features
## Reload templates
If you've added some templates, you can execute `templatize` on the image which will reprocess the templates and reload nginx.

Ex:
```
docker exec nginx-proxy templatize
```

<div class="panel panel-warning">**Warning**{: .panel-heading}
<div class="panel-body">
Depending on your template configuration, reprocessing the templates may overwrite the certbot changes from your web server.
</div></div>

## Reload Nginx
If you've just added files to the config, but they don't need to reprocess as templates, just reload Nginx:

```
docker exec nginx-proxy nginx -s reload
```

## Stopping Nginx
Send the stop command to the nginx executable:
```
docker exec nginx-proxy nginx -s stop
```
