FROM ubuntu:14.04

MAINTAINER "Dave Perrett" https://github.com/Dockerfile

# Dependencies
RUN apt-get -y update &&\
    apt-get install -y software-properties-common &&\
    apt-add-repository ppa:brightbox/ruby-ng &&\
    apt-get update -q

RUN apt-get install -y build-essential zlib1g-dev libxml2-dev \
    ruby2.2 ruby2.2-dev &&\
    gem install bundler --no-rdoc --no-ri

# Prepare
RUN mkdir /app
COPY . /app

# Install lean
RUN cd /app && bundle install --without development

# And run
WORKDIR /app
ENTRYPOINT ["bundle", "exec", "/app/bin/pivotal-to-trello"]
