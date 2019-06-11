FROM ruby:2.5
MAINTAINER Justin Downing <justin@downing.us>

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec rake spec
