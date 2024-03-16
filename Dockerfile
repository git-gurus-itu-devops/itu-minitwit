FROM ruby:3.3.0

RUN apt update && apt upgrade -y

ARG PORT=5000
ARG APP_ENV=production
ARG RACK_ENV=production
ARG MINITWIT_VERSION=latest
ENV APP_ENV=$APP_ENV
ENV RACK_ENV=$RACK_ENV
ENV PORT=$PORT
ENV MINITWIT_VERSION=$MINITWIT_VERSION

RUN mkdir -p /minitwit
WORKDIR /minitwit

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . ./

EXPOSE $PORT

CMD ["bundle", "exec", "ruby", "myapp.rb"]
