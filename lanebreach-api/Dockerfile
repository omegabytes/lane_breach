FROM ruby:2.5.1

ARG PORT=3000

# Setup the api application
RUN mkdir /lanebreach-api
WORKDIR /lanebreach-api
ADD Gemfile /lanebreach-api/Gemfile
ADD Gemfile.lock /lanebreach-api/Gemfile.lock
RUN bundle install
ADD . /lanebreach-api

EXPOSE $PORT
ENV RAILS_LOG_TO_STDOUT true
