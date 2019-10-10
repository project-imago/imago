# Imago elixir ?
FROM elixir:1.9.1
LABEL Nicolas Bettenburg <nicbet@gmail.com>

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN mix local.hex --force \
 && mix archive.install --force hex phx_new 1.4.10 \
 && apt-get update \
 && curl -sL https://deb.nodesource.com/setup_10.x | bash \
 && apt-get install -y apt-utils \
 && apt-get install -y nodejs \
 && apt-get install -y build-essential \
 && apt-get install -y inotify-tools \
 && mix local.rebar --force 

COPY ./mix.exs /app

RUN mix deps.get

COPY . /app

RUN mix ecto.setup \
 && mix ecto.create imago_eventstore_dev

VOLUME ["/app"]

EXPOSE 4000

CMD ["mix", "phx.server"]


