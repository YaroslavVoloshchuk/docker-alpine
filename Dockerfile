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

RUN addgroup -S -g 1001 nonroot && adduser -S -D -u 1001 -s /sbin/nologin -G nonroot nonroot

# Make sure files/folders needed by the processes are accessable when they run under the nonroot user
RUN chown -R nonroot.nonroot /var/www/html && \
  chown -R nonroot.nonroot /run && \
  chown -R nonroot.nonroot /var/lib/ && \
  chown -R nonroot.nonroot /var/log/ 
  

VOLUME ["/var/www/html"]

# Switch to use a non-root user from here on
USER nonroot

# Add application
WORKDIR /var/www/html

COPY --chown=nonroot car-rental/ /var/www/html/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

EXPOSE 80

#HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:80 || exit 1


