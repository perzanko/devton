FROM bitwalker/alpine-elixir-phoenix:latest

MAINTAINER Kacper Perzankowski

WORKDIR /opt/app

# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Copy all dependencies files
COPY mix.* ./

# Install all production dependencies
RUN mix deps.get --only prod

# Compile all dependencies
RUN mix deps.compile

RUN mix phx.digest

# Copy all application files
COPY . .
