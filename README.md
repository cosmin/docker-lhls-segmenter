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

## Testing

You can pipe mpegts output from ffmpeg to port `1234` in the above example and the resulting stream can be played at http://localhost:8080/stream.m3u8

For example on OS X you can run the following command to have ffmpeg stream video from the FaceTime camera (if one is present)

```
ffmpeg -r 30 -f avfoundation -i "0" -pix_fmt yuv420p -c libx264 -preset ultrafast -g 30 -keyint_min 30 -crf 25 -f mpegts tcp://localhost:1234
```
