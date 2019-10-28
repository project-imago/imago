# Imago

Imago is an experimental social network.
It is a work in progress.

## Run a development environment

### Using Docker

Follow the instructions in the [`imago-deploy` repository](https://gitlab.com/imago-project/imago_deploy)

### Without using Docker

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix do event_store.create, event_store.init, ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

  * Documentation: