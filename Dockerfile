FROM ruby:3.3.0

ARG PORT=5000
ARG APP_ENV=production
ENV APP_ENV=$APP_ENV
ENV PORT=$PORT

RUN mkdir -p /minitwit
WORKDIR /minitwit

RUN apt update && apt install sqlite3

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . ./

EXPOSE $PORT

CMD ["bundle", "exec", "ruby", "myapp.rb"]
