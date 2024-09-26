import Config

config :video_streamer, :file_storage, Video.FileStorage.S3

config :ex_aws,
  region: {:system, "AWS_REGION"}
