#!/usr/bin/env bash
apt update
apt install -y nginx
systemctl enable nginx
systemctl start nginx
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw enable
