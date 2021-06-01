FROM    alpine:3.13.3

LABEL maintainer="bamiks@gmail.com"
LABEL description="Docker image based on Ubuntu with some software as ngnix, php, git etc"

RUN apk update && apk --no-cache add \
    nginx \  
    bash \
    php8-fpm \
    php8 \
    busybox \
    nano \
    wget \
    curl \
    git \
    htop \
    vim \
    supervisor \
    mysql-client \
    redis \
    tzdata \
    openrc \
&& rm -rf /var/cache/apk/*  

RUN rm /etc/nginx/http.d/default.conf && cp /usr/share/zoneinfo/Europe/Kiev /etc/localtime

COPY supervisord.conf /etc/supervisord.conf 

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html && mkdir -p /run/nginx

RUN addgroup -g 1001 -S bamik && adduser -G bamik -u 1001 -s /bin/sh -D bamik

# Make sure files/folders needed by the processes are accessable when they run under the bamik user
RUN chown -R bamik.bamik /var/www/html && \
  chown -R bamik.bamik /run && \
  chown -R bamik.bamik /var/lib/ && \
  chown -R bamik.bamik /var/log/


VOLUME ["/var/www/html"]

# Switch to use a non-root user from here on
USER bamik

# Add application
WORKDIR /var/www/html

COPY --chown=bamik car-rental/ /var/www/html/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

EXPOSE 80

#HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:80 || exit 1


