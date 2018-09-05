#!/usr/bin/env bash

function start_segmenter() {
    cd /opt/segmenter
    ./transport-stream-segmenter-tcp.js 1234 /media segment_$(date +"%s")_ stream.m3u8 4 0.0.0.0 event 3  &
}

function start_chunk_web_server() {
    cd /opt/webserver
    ./index.js -p 5000 -d /media -a 127.0.0.1 >/dev/null 2>&1 &
}

function start_varnish() {
    service varnish start
}

function start() {
    start_segmenter
    start_chunk_web_server
    start_varnish
    wait $(jobs -p)
}

start
