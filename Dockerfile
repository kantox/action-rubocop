# syntax=docker/dockerfile:1.9
# check=error=true
ARG RUBY_VERSION=3.3.6-alpine
FROM ruby:${RUBY_VERSION} AS builder

RUN apk add --update --no-cache git cmake make g++ pcre-tools openssl-dev

COPY Gemfile* .ruby-version /tmp/
RUN cd /tmp && bundle

FROM ruby:${RUBY_VERSION}

RUN apk add --update --no-cache git

ENV REVIEWDOG_VERSION=v0.20.3

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ $REVIEWDOG_VERSION

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /src
WORKDIR /src
