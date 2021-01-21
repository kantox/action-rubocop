FROM ruby:3.0.0-alpine

ENV REVIEWDOG_VERSION v0.11.0
ENV RUBOCOP_VERSION 1.8.1

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --update --no-cache build-base git cmake make g++ openssl-dev
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ $REVIEWDOG_VERSION

COPY Gemfile* /tmp/
RUN cd /tmp && bundle

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /src
WORKDIR /src
