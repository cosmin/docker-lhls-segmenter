vcl 4.0;

backend default {
    .host = "localhost";
    .port = "5000";
}

sub vcl_recv {
    if (req.restarts == 0) {
        if (req.http.x-forwarded-for) {
            set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
        } else {
            set req.http.X-Forwarded-For = client.ip;
        }
    }

    if (req.http.Accept-Encoding) {
        if (req.url ~ "\.(ts|mp4|m4s|m4a)$") {
           unset req.http.Accept-Encoding;
        } elsif (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
        } elsif (req.http.Accept-Encoding ~ "deflate" && req.http.user-agent !~ "MSIE") {
            set req.http.Accept-Encoding = "deflate";
        } else {
            unset req.http.Accept-Encoding;
        }
    }

    if (req.method == "GET") {
        return(hash);
    }

    if (req.method != "GET" && req.method != "HEAD") {
        return(pipe);
    }

    return(hash);
}

sub vcl_backend_response {
    set beresp.grace = 600s;

    if (beresp.status >= 500) {
        set beresp.ttl = 0s;
    } else {
        set beresp.ttl = 4s;
    }

    set beresp.http.X-Cacheable = "YES";
    unset beresp.http.set-cookie;
    return(deliver);
}

sub vcl_deliver {
    set resp.http.X-Served-By = server.hostname;
    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
        set resp.http.X-Cache-Hits = obj.hits;
    } else {
        set resp.http.X-Cache = "MISS";
    }

    return(deliver);
}
