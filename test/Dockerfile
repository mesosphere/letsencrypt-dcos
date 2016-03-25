FROM debian:jessie

RUN apt-get update && apt-get -y install curl wget build-essential libreadline-dev libncurses5-dev libpcre3-dev libssl-dev && apt-get -q -y clean
RUN wget http://openresty.org/download/openresty-1.9.7.4.tar.gz \
  && tar xvfz openresty-1.9.7.4.tar.gz \
  && cd openresty-* \
  && ./configure --with-luajit --with-http_gzip_static_module  --with-http_ssl_module \
  && make \
  && make install \
  && rm -rf /openresty*

EXPOSE 8080
CMD /usr/local/openresty/nginx/sbin/nginx

ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
