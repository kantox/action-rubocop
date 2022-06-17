FROM ruby:3.0.0-alpine as builder

RUN apk add --update --no-cache git cmake make g++ pcre-tools openssl-dev

COPY Gemfile* /tmp/
RUN cd /tmp && bundle

FROM ruby:3.0.0-alpine

RUN wget -O v1.8.4.2.tar.gz https://github.com/git/git/archive/v1.8.4.2.tar.gz
RUN tar -xzvf ./v1.8.4.2.tar.gz
RUN cd git-1.8.4.2/ \
&& make prefix=/usr/local all \
&& make prefix=/usr/local install

ENV REVIEWDOG_VERSION v0.11.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ $REVIEWDOG_VERSION

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /src
WORKDIR /src
