#!/bin/sh
# vim:sw=4:ts=4:et

set -e

ME=$(basename "$0")

install_certificate() {
  if [ -z "${CERTBOT_EMAIL}" ]; then
    EMAIL=--register-unsafely-without-email

  else
    EMAIL="-m ${CERTBOT_EMAIL}"
  fi

  if [ -n "${CERTBOT_DOMAIN}" ]; then
    DOMAIN="${CERTBOT_DOMAIN}"

  elif [ -n "${NGINX_HOST}" ]; then
    DOMAIN=$(echo "${NGINX_HOST}" | tr ' ' ',')

  else
    # Certbot will die if this finds internal domains
    DOMAIN=$(nginx -qT | sed -rne 's/^\s*server_name\s+(.*);$/\1/p' \
      | tr '\n' ' ' | sed -r 's/\s+/ /g;s/^\s*//;s/\s*$//' | tr ' ' ',')
  fi

  # server must be defined in nginx config and match $NGINX_HOST or $DOMAIN
  echo $ME: Fetching certificate for "${DOMAIN}"

  certbot run --authenticator standalone --installer nginx \
  --keep-until-expiring --agree-tos --quiet --non-interactive \
  "${EMAIL}" ${CERTBOT_ARGS} --domain "${DOMAIN}"

  # Certbot leaves the web server running.
  # This container starts it later, so kill it now.
  while [ -e /var/run/nginx.pid ]; do
    nginx -s stop || break # break from loop if nginx can't receive signals
  done
}

install_certificate

exit 0
