# FROM ubuntu:latest

# WORKDIR /usr/share/nginx/html

# RUN apt update -y && apt upgrade -y && \
#     apt install -y nginx git && \
#     rm -rf /var/lib/apt/lists/*

# RUN rm -rf /usr/share/nginx/html/* && \
#     git clone --depth=1 https://github.com/nikkitagora/website . && \
#     [ -d "website/1dwebsite" ] && mv website/1dwebsite/* . || echo "Directory not found"
#     # git clone https://github.com/nikkitagora/website /usr/share/nginx/html && \
#     # mv /usr/share/nginx/html/website/1dwebsite/* /usr/share/nginx/html

# EXPOSE 8080

# CMD ["nginx", "-g", "daemon off;"]

FROM ubuntu:22.04

# Install Nginx, Git, and clean up apt cache
RUN apt update -y && \
    apt install -y nginx git && \
    rm -rf /var/lib/apt/lists/*

# Clone the website
RUN git clone https://github.com/nikkitagora/website /tmp/site

# Copy website files to Nginx web root
RUN mv /tmp/site/1dwebsite/* /usr/share/nginx/html/

RUN echo "user www-data;\
		worker_processes auto;\
		pid /run/nginx.pid;\
		include /etc/nginx/modules-enabled/*.conf;\
		events {\
		        worker_connections 768;\
		        # multi_accept on;\
		}\
		http {\
        server {\
                listen 8080;\
        }\
        sendfile on;\
        tcp_nopush on;\
        types_hash_max_size 2048;\
        include /etc/nginx/mime.types;\
        default_type application/octet-stream;\
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;\
        ssl_prefer_server_ciphers on;\
        access_log /var/log/nginx/access.log;\
        error_log /var/log/nginx/error.log;\
        gzip on;\
        include /etc/nginx/conf.d/*.conf;\
        include /etc/nginx/sites-enabled/*;\
}" > /etc/nginx/nginx.conf

EXPOSE 8080

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]