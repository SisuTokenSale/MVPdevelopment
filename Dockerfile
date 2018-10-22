FROM ruby:2.5.1

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends postgresql-client \
  libpq-dev \
  build-essential \
  git \
  libpq-dev \
  curl \
  apt-transport-https \
  && rm -rf /var/lib/apt/lists

# install Node
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
  && apt-get install -y nodejs

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
#CMD rails server -b 0.0.0.0
