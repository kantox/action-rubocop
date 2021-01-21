FROM ruby:3.0.0-alpine

ENV REVIEWDOG_VERSION v0.9.17
ENV RUBOCOP_VERSION 0.82

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --update --no-cache build-base git cmake openssl-dev
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ $REVIEWDOG_VERSION
RUN gem install -N rubocop:$RUBOCOP_VERSION \
                   rubocop-rails:2.6.0 \
                   rubocop-performance:1.7.1 \
                   rubocop-rspec:1.41.0 \
                   rubocop-i18n:2.0.2 \
                   rubocop-rake:0.4.0 \
                   pronto:0.10.0 \
                   pronto-rubocop:0.10.0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /src
WORKDIR /src
