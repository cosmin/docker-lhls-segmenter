# Docker LHLS Segmenter

A proof-of-concept LHLS segmenter using
https://github.com/jordicenzano/transport-stream-online-segmenter and
https://github.com/jordicenzano/webserver-chunked-growingfiles to
segment an incoming TS stream received via TCP and publish it to an LHLS playlist.

Varnish is used as a cached in front of the nodejs webserver

## Running

```
docker run -p 1234:1234 -p 8080:6081 offbytwo/lhls-segmenter
```
