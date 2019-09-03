FROM bitwalker/alpine-elixir-phoenix:latest

RUN mkdir /app
WORKDIR /app

# Set exposed ports
EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod

ADD . /app

# Cache elixir deps
ADD mix.exs mix.lock /app/
RUN mix do deps.get, deps.compile

USER default

CMD ["elixir", "--sname", "devton", "-S", "mix", "phx.server"]
