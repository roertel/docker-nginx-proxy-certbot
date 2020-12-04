#!/bin/sh

set -e

ME=$(basename $0)

install_certificate() {
  if [ -z "${CERTBOT_EMAIL}" ]; then
    EMAIL=--register-unsafely-without-email
  else
    EMAIL="-m ${CERTBOT_EMAIL}"
  fi

  # server must be defined in nginx config and match $NGINX_HOST
  certbot run --authenticator standalone --installer nginx \
    --agree-tos ${EMAIL} ${CERTBOT_ARGS}    
}

install_certificate

exit 0
