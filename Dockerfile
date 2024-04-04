FROM ruby:3.3.0

# https://github.com/hadolint/hadolint/wiki/DL3009
RUN apt-get update && apt-get upgrade -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ARG PORT=5000
ARG APP_ENV=production
ARG RACK_ENV=production
ENV APP_ENV=$APP_ENV
ENV RACK_ENV=$RACK_ENV
ENV PORT=$PORT

RUN mkdir -p /minitwit
WORKDIR /minitwit

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem install bundler:2.5.6 && bundle install

COPY . ./

EXPOSE $PORT

CMD ["bundle", "exec", "ruby", "myapp.rb"]
