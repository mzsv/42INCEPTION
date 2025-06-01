# Inception - Docker Infrastructure Project

## Contents

1. [Overview](#overview)
2. [Objectives](#objectives)
3. [Features](#features)
4. [Project Structure](#project-structure)
5. [Usage](#usage)
6. [Acknowledgments](#acknowledgments)

## Overview

**Inception** is a system administration and DevOps project from 42 School. The goal is to containerize a secure WordPress-based web infrastructure using Docker and Docker Compose.

All services are containerized with strict isolation, and built from scratch using Dockerfiles based on Alpine. No pre-built images or public registries (like DockerHub) are used, ensuring full control and understanding of the setup.

## Features

### Services

**Nginx**	Serves the WordPress site over HTTPS (TLSv1.2/1.3).

**WordPress**	Runs WordPress with php-fpm only (no nginx).

**MariaDB**	Stores WordPress data securely.

### Docker Secrets & Security

No credentials or secrets are hardcoded or pushed to Git.

All secrets (DB passwords, admin credentials, etc.) are stored in the secrets/ directory and are ignored via .gitignore.

HTTPS is enabled using self-signed certificates placed under requirements/nginx/tools (generated automatically via Makefile).

### Docker Networks

All containers communicate securely via a custom user-defined Docker bridge network, as required. docker-compose.yml defines the network explicitly.

Containers are isolated from the host network and communicate internally.

No use of network: host, --link, or links. Only port 443 is exposed to the host machine (for HTTPS via NGINX).

### Docker Volumes

The following volumes are used and mounted under /home/<username>/data

## Project Structure

```
├── Makefile
├── secrets
│   ├── adm_wp_password.txt
│   ├── credentials.txt
│   ├── db_password.txt
│   ├── db_root_password.txt
│   └── wp_password.txt
└── srcs
    ├── docker-compose.yml
    ├── env
    └── requirements
        ├── mariadb
        │   ├── conf
        │   │   └── startup.sh
        │   ├── Dockerfile
        │   └── tools
        │       └── createDbPaths.sh
        ├── nginx
        │   ├── conf
        │   │   └── nginx.conf
        │   ├── Dockerfile
        │   └── tools
        │       ├── johndoe.42.fr.crt
        │       └── johndoe.42.fr.key
        ├── tools
        │   ├── generateCerts.sh
        │   ├── generateDummySecrets.sh
        │   └── generateEnv.sh
        └── wordpress
            ├── conf
            │   └── startup.sh
            ├── Dockerfile
            └── tools
```

## Usage

This project is fully managed via make commands for building, running, and cleaning the Docker-based infrastructure. It runs entirely inside Docker containers using Docker Compose, with NGINX serving over HTTPS (port 443 only).

### Build and Run the Project

Run at project root directory:
```
make
```
Builds all Docker images, sets up environment variables and certificates, prepares database paths, and starts the entire infrastructure.

**Note:** the Secrets/ directory and its files are not publicly available in the repository for security reasons. A dummy Secrets generator is provided for testing purposes. The secrets should be generated (or provided) before running "make". Usage:

```
make dummy-secrets
```

### Other Makefile rules

_make rebuild_: Rebuilds everything from scratch

_make build_: Builds the Docker images without starting the containers.

_make down_: Stops all running containers defined in docker-compose.yml.

_make clean_: Cleans containers, volumes, and orphaned services. Also removes the ~/data folder.
    
_make fclean_: Full cleanup (system prune).

_make certs_: Generates TSL certificates.

_make env_: Generates .env file.

## Acknowledgements

Thanks to the 42 Network for providing this project and development environment.

Thanks to fellow students and the 42 Porto community for collaboration and discussions.
