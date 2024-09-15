defmodule Video.Streamer do
  use Plug.Router
  import Plug.Conn

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
    stream_video(conn, "SampleVideo_1280x720_1mb.mp4")
  end

  @spec get_video_dir() :: String.t()
  defp get_video_dir do
    priv_dir = :code.priv_dir(:video_streamer)
    Path.join(priv_dir, "videos")
  end

  @spec stream_video(Plug.Conn.t(), String.t()) :: Plug.Conn.t()
  defp stream_video(conn, filename) do
    # Sanitize the filename to prevent directory traversal attacks
    safe_filename = Path.basename(filename)
    video_dir = get_video_dir()
    filepath = Path.join(video_dir, safe_filename)

    case File.stat(filepath) do
      {:ok, _info} ->
        conn =
          conn
          |> put_resp_content_type("video/mp4")
          |> send_chunked(200)

        filepath
        |> File.stream!(2048)
        |> Enum.reduce_while(conn, fn chunk, conn ->
          case chunk(conn, chunk) do
            {:ok, conn} -> {:cont, conn}
            {:error, _reason} -> {:halt, conn}
          end
        end)

      {:error, _reason} ->
        send_resp(conn, 404, "File not found")
    end
  end
end
