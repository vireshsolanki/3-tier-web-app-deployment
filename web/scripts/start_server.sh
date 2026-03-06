#!/bin/bash
cd /var/www/web
npm install
# Ensure PM2 has a home directory even in SSM
export HOME=/root
pm2 delete web || true
pm2 start ./bin/www --name "web"
pm2 save
