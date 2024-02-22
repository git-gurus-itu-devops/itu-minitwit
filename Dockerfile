FROM ruby:3.3.0

ARG PORT=5000
ARG APP_ENV=production
ENV APP_ENV=$APP_ENV
ENV PORT=$PORT

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . ./

EXPOSE $PORT
