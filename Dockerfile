FROM ruby:2.1-onbuild
MAINTAINER Justin Downing <justin@downing.us>

RUN bundle exec rake spec
