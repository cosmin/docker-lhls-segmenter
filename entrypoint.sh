#!/usr/bin/env bash

function start_segmenter() {
    cd /opt/segmenter
    ./transport-stream-segmenter-tcp.js 1234 /media segment_ stream.m3u8 4 0.0.0.0 event 3  &
}

function start_chunk_web_server() {
    cd /opt/webserver
    ./index.js -p 8080 -d /media -a 0.0.0.0 &
}

function start() {
    start_segmenter
    start_chunk_web_server
    wait $(jobs -p)
}

start
