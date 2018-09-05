#!/usr/bin/env bash

function start_segmenter() {
    cd /opt/segmenter
    ./transport-stream-segmenter-tcp.js 1234 /media segment_ stream.m3u8 4 0.0.0.0 event 3  &
}

function start_chunk_web_server() {
    cd /opt/webserver
    ./index.js -p 8888 -d /media -a 127.0.0.1 &
}

function start_nginx() {
    nginx
}


function start() {
    start_segmenter
    start_chunk_web_server
    start_nginx
    echo "Segmenter listening on port 1234"
    echo "Web server listening on port 8080"
    wait $(jobs -p)
}

start
