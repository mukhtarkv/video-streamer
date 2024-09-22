import Config

config :video_streamer, port: 5454
config :video_streamer, :file_storage, Video.FileStorage.Local

import_config "#{config_env()}.exs"
