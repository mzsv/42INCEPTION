#!/bin/sh

DOMAIN_NAME=johndoe.42.fr
CERT_=./requirements/tools/johndoe.42.fr.crt
KEY_=./requirements/tools/johndoe.42.fr.key
DB_NAME=dbname
DB_USER=dbuser
DB_HOST=mariadb
WP_TITLE=INCEPTION_johndoe
WP_USERNAME=user
WP_USEREMAIL=user@42.fr
WP_HOST=johndoe.42.fr
ADM_WP_NAME=boss
ADM_WP_EMAIL=johndoe@42.fr

DB_PASS=123
DB_ROOT=123
WP_PASS=123
ADM_WP_PASS=123

mkdir -p secrets

cat > secrets/credentials.txt <<EOF
DOMAIN_NAME=johndoe.42.fr
CERT_=./requirements/tools/johndoe.42.fr.crt
KEY_=./requirements/tools/johndoe.42.fr.key
DB_NAME=dbname
DB_USER=dbuser
DB_HOST=mariadb
WP_TITLE=INCEPTION_johndoe
WP_USERNAME=user
WP_USEREMAIL=user@42.fr
WP_HOST=johndoe.42.fr
ADM_WP_NAME=boss
ADM_WP_EMAIL=johndoe@42.fr
EOF

touch secrets/adm_wp_password.txt
echo $ADM_WP_PASS > secrets/adm_wp_password.txt

touch secrets/db_password.txt
echo $DB_PASS > secrets/db_password.txt

touch secrets/db_root_password.txt
echo $DB_ROOT > secrets/db_root_password.txt

touch secrets/wp_password.txt
echo $WP_PASS > secrets/wp_password.txt

chmod 777 secrets/*.txt

echo "Dummy Secrets created successfully!"
