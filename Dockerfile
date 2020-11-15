#FROM elixir:1.10.4-alpine as builder
FROM hexpm/elixir:1.11.1-erlang-23.0.2-alpine-3.12.0 as builder

# install build dependencies
RUN apk add --no-cache build-base npm git 

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy

COPY config config
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image

# ===========================================

FROM alpine:3
RUN apk add --no-cache openssl ncurses-libs bash file curl

WORKDIR /app
COPY --from=builder /app/_build/prod/rel/redirex/ .

EXPOSE 4000

ENTRYPOINT ["/app/bin/redirex"]
CMD ["start"]



# FROM alpine:3.9 AS app
# RUN apk add --no-cache openssl ncurses-libs bash file curl 

# WORKDIR /app

# RUN chown nobody:nobody /app

# USER nobody:nobody

# COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/my_app ./

# ENV HOME=/app

# CMD ["bin/my_app", "start"]