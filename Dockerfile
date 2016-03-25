FROM debian:jessie

WORKDIR /
RUN apt-get update && apt-get install -y unzip curl python-requests
RUN curl -Ls -o /master.zip https://github.com/letsencrypt/letsencrypt/archive/master.zip
RUN unzip master.zip \
  && cd letsencrypt-master \
  && ./letsencrypt-auto --help \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80

WORKDIR /letsencrypt-master
COPY run.sh /letsencrypt-master/run.sh
COPY post_cert.py /letsencrypt-master/post_cert.py

ENTRYPOINT ["/letsencrypt-master/run.sh"]
