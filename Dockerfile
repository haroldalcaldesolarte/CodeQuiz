FROM ruby:3.0.3

# Instala dependencias del sistema y Node.js 18
RUN apt-get update -qq && apt-get install -y \
  curl gnupg build-essential libpq-dev git \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && npm install --global yarn

# Establece la variable de entorno necesaria para Webpacker
ENV NODE_OPTIONS=--openssl-legacy-provider

# Directorio de trabajo
WORKDIR /app

# Copia las gemas y las instala
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copia el resto del código fuente
COPY . .

# Precompila assets
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Expone el puerto 3000 internamente
EXPOSE 3000

# Comando por defecto
CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails s -e production -b 0.0.0.0 -p 3000"]