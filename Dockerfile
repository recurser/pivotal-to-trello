FROM ruby:2.6

MAINTAINER "Dave Perrett" https://github.com/Dockerfile

RUN gem install bundler

# Prepare
RUN mkdir /app
COPY . /app

# Install lean
RUN cd /app && bundle install --without development

# And run
WORKDIR /app
ENTRYPOINT ["bundle", "exec", "/app/bin/pivotal-to-trello"]
