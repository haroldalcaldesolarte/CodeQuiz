FROM ruby:3.0.3

RUN apt-get update -qq && apt-get install -y \
  curl gnupg build-essential libpq-dev git \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && npm install --global yarn

ENV NODE_OPTIONS=--openssl-legacy-provider

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test

COPY . .

RUN RAILS_ENV=production bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails s -e production -b 0.0.0.0 -p 3000"]
