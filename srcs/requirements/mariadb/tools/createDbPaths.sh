#!/bin/sh

DATA_DIR="/home/${USER}/data"

if [ ! -d "$DATA_DIR" ]; then
    echo "Creating $DATA_DIR directories for MariaDB and WordPress..."
    mkdir -p "$DATA_DIR/mariadb"
    mkdir -p "$DATA_DIR/wordpress"
fi
