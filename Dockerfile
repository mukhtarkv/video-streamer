# Stage 1: Build stage
FROM elixir:1.16.3-alpine AS builder

# Install Git and build dependencies
RUN apk update && \
    apk add --no-cache git build-base

ARG APP_NAME=video_streamer
ARG MIX_ENV

# Set the working directory in the container
WORKDIR /opt/build

COPY . .

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix deps.get
RUN mix deps.compile

RUN mix compile
RUN mix release ${APP_NAME}
RUN cp -R /opt/build/_build/${MIX_ENV}/rel /opt/build/built_rel

# Stage 2: Release stage
FROM elixir:1.16.3-alpine

# Install runtime dependencies and necessary build tools
RUN apk update && apk add --no-cache \
    curl \
    snappy \
    openssl \
    zlib-dev \
    ncurses \
    readline \
    libxml2 \
    libxslt

RUN mkdir /app
WORKDIR /app

COPY --from=builder /opt/build/built_rel/video_streamer .
COPY --from=builder --chmod=555 /opt/build/bin/console /app/bin/console
# --chmod=555 grants read and execute privileges to the owner, group, and others, respectively.

# Specify the default command to run when starting the container
CMD ["/app/bin/video_streamer", "start"]

