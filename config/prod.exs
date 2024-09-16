import Config

config :video_streamer, :file_storage, Video.FileStorage.S3
config :video_streamer, :s3_bucket, "video-streamer-videos"

config :ex_aws,
  region: {:system, "AWS_REGION"}
