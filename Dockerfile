FROM bitwalker/alpine-elixir-phoenix:1.9.4

ENV HEX_HTTP_CONCURRENCY=1
ENV HEX_HTTP_TIMEOUT=240
ENV MIX_ENV=dev

# Cache elixir deps
COPY ./mix.exs ./mix.lock /opt/app/
RUN mix do deps.get, deps.compile

# Same with npm deps
COPY ./assets/package.json /opt/app/assets/
RUN cd assets && \
    npm install --ignore-optional

# ADD . .

# Run frontend build, compile, and digest assets
# RUN cd assets/ && \
#     npm run deploy && \
#     cd - && \
#     mix do compile, phx.digest

COPY ./lib /opt/app/lib/
COPY ./config /opt/app/config/
RUN mix compile

# VOLUME ["/opt/app/lib"]
# VOLUME ["/opt/app/assets"]
# VOLUME ["/opt/app/priv"]

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait

# Set exposed ports
EXPOSE 4000

USER default

CMD /wait && mix phx.server
