#!/bin/bash
# Stop any running PM2 processes for web
pm2 stop web || true
pm2 delete web || true
