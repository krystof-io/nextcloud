FROM nextcloud:29.0.5-apache

RUN apt-get update && apt-get install -y procps smbclient && rm -rf /var/lib/apt/lists/*
