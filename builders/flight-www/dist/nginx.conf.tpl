user nobody %GROUP%;
worker_processes 1;
error_log /opt/flight/var/log/www/error.log warn;
pid /opt/flight/var/run/www.pid;

events {
    worker_connections 1024;
}

http {
    include /opt/flight/opt/www/embedded/conf/mime.types;
    default_type application/octet-stream;
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    access_log /opt/flight/var/log/www/access.log main;
    sendfile on;
    #tcp_nopush on;
    keepalive_timeout 65;
    gzip on;
    error_page 404 /not-found;
    include /opt/flight/etc/www/http.d/*.conf;
}
