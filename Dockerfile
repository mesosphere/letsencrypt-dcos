FROM debian:jessie

WORKDIR /
RUN apt-get update && apt-get install -y unzip curl python-requests
RUN curl -Ls -o /master.zip https://github.com/certbot/certbot/archive/master.zip
RUN unzip master.zip \
  && cd certbot-master \
  && ./certbot-auto --help \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80

WORKDIR /certbot-master
COPY run.sh /certbot-master/run.sh
COPY post_cert.py /certbot-master/post_cert.py

ENTRYPOINT ["/certbot-master/run.sh"]
