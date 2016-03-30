#!/bin/bash
set -e

# Wait to settle
sleep 10

IFS=',' read -ra ADDR <<< "$SSL_DOMAINS"
DOMAIN_ARGS=""
DOMAIN_FIRST=""
for i in "${ADDR[@]}"; do
  if [ -z $DOMAIN_FIRST ]; then
    DOMAIN_FIRST=$i
  fi
  DOMAIN_ARGS="$DOMAIN_ARGS -d $i"
done


echo "DOMAIN_ARGS: ${DOMAIN_ARGS}"
echo "DOMAIN_FIRST: ${DOMAIN_FIRST}"

echo "Running letsencrypt-auto to generate initial signed cert"
./letsencrypt-auto certonly --standalone --standalone-supported-challenges http-01 \
  $DOMAIN_ARGS --email $SSL_EMAIL --agree-tos --non-interactive --no-redirect \
  --rsa-key-size 4096 --expand

while [ true ]; do
  cat /etc/letsencrypt/live/$DOMAIN_FIRST/fullchain.pem \
    /etc/letsencrypt/live/$DOMAIN_FIRST/privkey.pem >   \
    /etc/letsencrypt/live/$DOMAIN_FIRST.pem

  echo "Posting new cert to marathon-lb"
  ./post_cert.py /etc/letsencrypt/live/$DOMAIN_FIRST.pem

  sleep 24h

  echo "About to attempt renewal"
  ./letsencrypt-auto renew
done
