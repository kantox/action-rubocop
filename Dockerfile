FROM ruby:2.7.1-alpine

ENV REVIEWDOG_VERSION v0.9.17

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --update --no-cache build-base git
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ $REVIEWDOG_VERSION
RUN gem install -N rubocop=0.81 rubocop-rails rubocop-performance rubocop-rspec rubocop-i18n rubocop-rake

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
