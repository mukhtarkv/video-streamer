defmodule Video.Streamer do
  use Plug.Router
  import Plug.Conn
  alias Video.FileStorage
  alias Video.Metrics
  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  @port Application.compile_env!(:video_streamer, :port)

  def child_spec(_arg) do
    Plug.Cowboy.child_spec(
      scheme: :http,
      options: [port: @port],
      plug: __MODULE__
    )
  end

  get "/video" do
    Metrics.viewed("SampleVideo_1280x720_1mb.mp4")
    stream_video(conn, "SampleVideo_1280x720_1mb.mp4")
  end

  @spec stream_video(Plug.Conn.t(), String.t()) :: Plug.Conn.t()
  defp stream_video(conn, filename) do
    # Sanitize the filename to prevent directory traversal attacks
    safe_filename = Path.basename(filename)

    case FileStorage.stream_file(safe_filename) do
      {:ok, stream} ->
        conn =
          conn
          |> put_resp_content_type("video/mp4")
          |> send_chunked(200)

        Enum.reduce_while(stream, conn, fn chunk, conn ->
          case chunk(conn, chunk) do
            {:ok, conn} -> {:cont, conn}
            {:error, _reason} -> {:halt, conn}
          end
        end)

      {:error, reason} ->
        send_resp(conn, 404, "Error reading file: #{reason}")
    end
  end
end
