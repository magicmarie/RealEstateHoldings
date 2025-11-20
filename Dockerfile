FROM ruby:3.3.5-slim-bookworm

WORKDIR /app

ARG UID=1000
ARG GID=1000

RUN bash -c "set -o pipefail && apt-get update \
      && apt-get install -y --no-install-recommends build-essential curl git libpq-dev \
      && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key -o /etc/apt/keyrings/nodesource.asc \
      && echo 'deb [signed-by=/etc/apt/keyrings/nodesource.asc] https://deb.nodesource.com/node_20.x nodistro main' | tee /etc/apt/sources.list.d/nodesource.list \
      && apt-get update && apt-get install -y --no-install-recommends nodejs \
      && corepack enable \
      && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
      && apt-get clean \
      && groupadd -g \"${GID}\" ruby \
      && useradd --create-home --no-log-init -u \"${UID}\" -g \"${GID}\" ruby \
      && chown ruby:ruby -R /app"

USER ruby

COPY --chown=ruby:ruby Gemfile* ./
RUN bundle install

COPY --chown=ruby:ruby package.json *yarn* ./
RUN yarn install

ARG RAILS_ENV="development"
ARG NODE_ENV="development"
ENV RAILS_ENV="${RAILS_ENV}" \
    NODE_ENV="${NODE_ENV}" \
    PATH="/app/node_modules/.bin:/home/ruby/.local/bin:$PATH" \
    USER="ruby"

COPY --chown=ruby:ruby . .

RUN chmod 0755 bin/*

EXPOSE 3000

CMD ["bash"]
