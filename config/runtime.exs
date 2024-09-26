import Config

unless config_env() == :test do
  config :video_streamer, :s3_bucket, System.get_env("S3_BUCKET")
end
