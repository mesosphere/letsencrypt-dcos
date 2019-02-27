FROM debian:jessie

WORKDIR /
ENV DEBIAN_FRONTEND=noninteractive
ENV CERTBOT_VERSION=0.26.1
RUN apt-get update \
  && apt-get install -y unzip curl python-pip \
  && pip install --upgrade pip \
  && pip install virtualenv --upgrade \
  && curl -Ls -o /certbot.zip https://github.com/certbot/certbot/archive/v${CERTBOT_VERSION}.zip \
  && unzip certbot.zip \
  && mv certbot-${CERTBOT_VERSION} certbot \
  && cd certbot \
  && ./certbot-auto --os-packages-only --noninteractive \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80

WORKDIR /certbot
COPY run.sh /certbot/run.sh
COPY post_cert.py /certbot/post_cert.py

ENTRYPOINT ["/certbot/run.sh"]
