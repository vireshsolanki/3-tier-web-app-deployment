#!/bin/bash
cd /var/www/api
npm install
# The app connects to the DB based on env vars, which can be injected via parameter store or systemd
# For now, start process using pm2
pm2 start ./bin/www --name "api"
pm2 save
