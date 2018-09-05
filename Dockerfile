FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends ca-certificates javascript-common git nodejs npm nginx varnish  && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get -y clean && \
    rm -r /var/lib/apt/lists/*

RUN git clone --branch master --depth 1 https://github.com/jordicenzano/webserver-chunked-growingfiles.git /opt/webserver && \
    cd /opt/webserver && \
    npm install

RUN git clone --branch master --depth 1 https://github.com/jordicenzano/transport-stream-online-segmenter.git /opt/segmenter && \
    cd /opt/segmenter && \
    npm install

COPY nginx.conf /etc/nginx/
COPY proxy.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/
COPY entrypoint.sh /root
RUN chmod +x /root/entrypoint.sh

# web server port
EXPOSE 8080/tcp

# TS tcp stream inbound
EXPOSE 1234/tcp

# files will go here
VOLUME /media

ENTRYPOINT /root/entrypoint.sh
