defmodule Video.FileStorage do
  @behaviour Video.FileStorage.Behaviour

  @impl true
  def stream_file(path), do: impl().stream_file(path)

  defp impl do
    Application.get_env(:video_streamer, :file_storage, Video.FileStorage.Local)
  end
end
