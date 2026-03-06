#!/bin/bash
# Stop any running PM2 processes for api
pm2 stop api || true
pm2 delete api || true
