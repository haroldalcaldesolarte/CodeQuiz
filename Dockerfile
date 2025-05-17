FROM ruby:3.0.3

# Instala dependencias del sistema y Node.js 18
RUN apt-get update -qq && apt-get install -y curl gnupg build-essential libpq-dev git \
 && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && npm install --global yarn

ENV NODE_OPTIONS=--openssl-legacy-provider


# Establece directorio de trabajo
WORKDIR /app

# Copia las gemas
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia el resto de la app
COPY . .

# Instala JS
RUN yarn install

# Precompila assets si es necesario
RUN bundle exec rake assets:precompile

# Expone puerto de Rails
EXPOSE 3000

# Comando por defecto
CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails s -b 0.0.0.0"]