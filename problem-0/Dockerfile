# Base
FROM elixir:1.14-slim AS base

WORKDIR /app
ADD . /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs .
COPY mix.lock .
RUN mix deps.get


# Release
FROM base AS release

ARG PORT
ENV PORT=${PORT}
ENV MIX_ENV=prod
RUN mix release


# Production
FROM release AS production

CMD ["_build/prod/rel/problem0/bin/problem0", "start"]
