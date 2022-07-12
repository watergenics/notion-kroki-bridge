FROM ruby:3.1

COPY . /app
WORKDIR /app
RUN gem install -g
ENV RUBYGEMS_GEMDEPS=- RACK_ENV=production
CMD puma
