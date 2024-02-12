FROM ruby:3.3.0

ENV PORT 5000

ARG APP_ENV=production
ENV APP_ENV=$APP_ENV

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile ./
COPY Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . ./

EXPOSE 5000

CMD ["bundle", "exec", "ruby", "myapp.rb"]
