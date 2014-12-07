FROM ubuntu:14.04

MAINTAINER "Kenneth Kalmer" https://github.com/kennethkalmer

# Dependencies
RUN apt-get -y update &&\
    apt-get install -y software-properties-common &&\
    apt-add-repository ppa:brightbox/ruby-ng &&\
    apt-get update -q

RUN apt-get install -y build-essential zlib1g-dev libxml2-dev \
    ruby2.1 ruby2.1-dev &&\
    gem install bundler --no-rdoc --no-ri

# Prepare
RUN mkdir /app
COPY . /app

# Install lean
RUN cd /app && bundle install --without development

# And run
ENTRYPOINT ["/app/bin/pivotal-to-trello"]
