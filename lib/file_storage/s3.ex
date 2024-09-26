defmodule Video.FileStorage.S3 do
  @behaviour Video.FileStorage.Behaviour
  alias ExAws.S3
  require Logger

  defp bucket do
    Application.get_env(:video_streamer, :s3_bucket)
  end

  @impl true
  def stream_file(path) do
    Logger.info("Downloading file from S3: #{path}")

    stream =
      S3.download_file(bucket(), path, :memory)
      |> ExAws.stream!()

    {:ok, stream}
  end
end
