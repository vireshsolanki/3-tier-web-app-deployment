#!/bin/bash
cd /var/www/api
npm install
# Ensure PM2 has a home directory even in SSM
export HOME=/root
pm2 delete api || true
pm2 start ./bin/www --name "api"
pm2 save
