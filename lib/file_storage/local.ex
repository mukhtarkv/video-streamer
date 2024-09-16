defmodule Video.FileStorage.Local do
  @behaviour Video.FileStorage.Behaviour
  require Logger

  @spec get_video_dir() :: String.t()
  defp get_video_dir do
    :code.priv_dir(:video_streamer)
    |> Path.join("videos")
  end

  @spec full_path(String.t()) :: String.t()
  defp full_path(path), do: get_video_dir() |> Path.join(path)

  @impl true
  def stream_file(path) do
    full_path = full_path(path)

    case File.stat(full_path) do
      {:ok, _info} ->
        Logger.info("Streaming file: #{full_path}")
        # 64KB chunks
        {:ok, File.stream!(full_path, 64 * 1024)}

      {:error, reason} ->
        Logger.error("Error reading file: #{reason}")
        {:error, reason}
    end
  end
end
