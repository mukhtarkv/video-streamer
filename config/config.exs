import Config

config :video_streamer, port: 5454
config :video_streamer, :file_storage, Video.FileStorage.Local

# Configures Elixir's Logger
config :logger, :default_handler, formatter: {LoggerJSON.Formatters.Basic, metadata: :all}

import_config "#{config_env()}.exs"
