#!/bin/sh

echo "Loading database passwords from secrets..."
export DB_PASS=$(cat /run/secrets/db_password)
export DB_ROOT=$(cat /run/secrets/db_root_password)
export WP_PASS=$(cat /run/secrets/wp_password)
export ADM_WP_PASS=$(cat /run/secrets/adm_wp_password)

# Wait for MariaDB to be ready (5 attempts max)
MAX_RETRIES=5
COUNT=0

until mysqladmin ping -h "${DB_HOST}" -u"${DB_USER}" -p"${DB_PASS}" --silent; do
  if [ $COUNT -ge $MAX_RETRIES ]; then
    echo "Max retries reached. MariaDB is still unavailable. Exiting."
    exit 1
  fi

  echo "Waiting for DB at ${DB_HOST}... (Attempt $((COUNT+1))/$MAX_RETRIES)"
  COUNT=$((COUNT+1))
  sleep 3
done

echo "MariaDB is up!"

if [ ! -f "/var/www/wp-config.php" ]; then
    echo "Initializing WordPress volume with default files..."
    cp -R /usr/src/wordpress/* /var/www/
    chown -R nobody:nogroup /var/www/
fi

cd /var/www/

if ! wp core is-installed --allow-root; then
    echo "Setting up wp-config and installing WordPress..."
    wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASS}" \
        --dbhost="${DB_HOST}" \
        --allow-root \
        --force
    wp config set FS_METHOD 'direct' --allow-root
    wp core install \
        --url="https://${WP_HOST}" \
        --title="${WP_TITLE}" \
        --admin_user="${ADM_WP_NAME}" \
        --admin_password="${ADM_WP_PASS}" \
        --admin_email="${ADM_WP_EMAIL}" \
        --allow-root
    if ! wp user get "${WP_USERNAME}" --allow-root > /dev/null 2>&1; then
      wp user create "${WP_USERNAME}" "${WP_USEREMAIL}" \
          --role="editor" --user_pass="${WP_PASS}" --allow-root
    fi
fi

php-fpm83 -F
