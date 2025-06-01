#!/bin/sh

CERT="srcs/requirements/nginx/tools/${USERNAME}.42.fr.crt"
KEY="srcs/requirements/nginx/tools/${USERNAME}.42.fr.key"
DOMAIN="https://${USERNAME}.42.fr"

if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
    echo "Generating mkcert certificate and key..."
    mkcert -key-file "$KEY" -cert-file "$CERT" "$DOMAIN"
    chmod 777 $KEY $CERT
    mkcert -install
else
    echo "Certificate and key already exist, skipping generation."
fi
