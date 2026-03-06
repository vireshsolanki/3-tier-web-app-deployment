#!/bin/bash
cd /var/www/web
npm install
# Start process using pm2 (installed via UserData)
pm2 start ./bin/www --name "web"
pm2 save
