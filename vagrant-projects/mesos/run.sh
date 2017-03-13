#!/bin/sh

start_busybox_app () {
  curl -X POST -H "Content-Type: application/json" http://100.0.10.11:8080/v2/apps -d@tests/apps/busybox.json
}

start_httpserver_app () {
  curl -X POST -H "Content-Type: application/json" http://100.0.10.11:8080/v2/apps -d@tests/apps/http-server.json
}

start_curl_app () {
  curl -X POST -H "Content-Type: application/json" http://100.0.10.11:8080/v2/apps -d@tests/apps/curl.json
}

echo "Starting busybox...\n"
start_busybox_app
echo "\n---\n"
sleep 10

echo "Starting HTTP server...\n"
start_httpserver_app
echo "\n---\n"
sleep 30

echo "Starting curl...\n"
start_curl_app
