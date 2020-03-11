FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 4000
ENV MIX_ENV=dev

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
    npm install

ADD . .

# Run frontend build, compile, and digest assets
# RUN cd assets/ && \
#     npm run deploy && \
#     cd - && \
#     mix do compile, phx.digest

RUN mix compile

VOLUME ["/opt/app/lib"]
VOLUME ["/opt/app/assets"]
VOLUME ["/opt/app/priv"]

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait

USER default

CMD mix ecto.setup; \
CMD mix do event_store.create, event_store.init; \
CMD /wait && mix phx.server
