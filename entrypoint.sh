#!/usr/bin/env bash

set -e

segment_duration=4
playlist_type=live
segments=3

while getopts "d:t:s:" opt; do
    case $opt in
        d)
            segment_duration=$OPTARG
            ;;
        t)
            playlist_type=$OPTARG
            ;;
        s)
            segments=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done


function start_segmenter() {
    cd /opt/segmenter
    ./transport-stream-segmenter-tcp.js 1234 /media segment_$(date +"%s")_ stream.m3u8 $segment_duration 0.0.0.0 $playlist_type $segments &
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
