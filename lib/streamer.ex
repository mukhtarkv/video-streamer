defmodule Video.Streamer do
  use Plug.Router
  import Plug.Conn
  alias Video.FileStorage
  alias Video.Metrics
  require Logger

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)
  plug(Plug.Telemetry, event_prefix: [:prometheus_metrics, :plug])

  def child_spec(args) do
    Plug.Cowboy.child_spec(
      scheme: Keyword.get(args, :protocol),
      options: Keyword.get(args, :options),
      plug:
        {__MODULE__,
         [
           name: Keyword.get(args, :name)
         ]}
    )
  end

  get "/metrics" do
    name = :prometheus_metrics

    metrics = TelemetryMetricsPrometheus.Core.scrape(name)

    conn
    |> put_private(:prometheus_metrics_name, name)
    |> put_resp_content_type("text/plain")
    |> send_resp(200, metrics)
  end

  @spec default_pre_scrape_handler() :: :ok
  def default_pre_scrape_handler, do: :ok

  get "/video" do
    Metrics.viewed("SampleVideo_1280x720_1mb.mp4")
    stream_video(conn, "SampleVideo_1280x720_1mb.mp4")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
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
