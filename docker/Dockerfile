FROM nginx

RUN apt-get update
RUN apt-get install -y curl unzip

# Install Summon and the Conjur provider for summon
WORKDIR /tmp
RUN curl -o summon.tgz -sSL https://github.com/conjurinc/summon/releases/download/v0.4.0/summon_v0.4.0_linux_amd64.tar.gz
RUN tar -xf summon.tgz
RUN mv summon /usr/local/bin

RUN curl -o summon-conjur.zip -sSL https://github.com/conjurinc/summon-conjur/releases/download/v0.1.4/summon-conjur_v0.1.4_linux-amd64.zip
RUN unzip summon-conjur.zip
RUN mkdir -p /usr/local/lib/summon
RUN mv summon-conjur /usr/local/lib/summon

RUN rm summon*

COPY entrypoint /usr/bin
COPY nginx.conf /etc/nginx/
COPY secrets.yml /etc/nginx/



WORKDIR /etc/nginx

CMD ["entrypoint"]