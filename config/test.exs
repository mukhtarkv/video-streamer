import Config

config :video_streamer, :s3_bucket, "test-videos"

config :ex_aws,
  access_key_id: "dummy_access_key_id",
  secret_access_key: "dummy_secret_access_key",
  region: "us-east-1",
  http_client: HttpClientMock
