defmodule Video.Application do
  use Application
  @port Application.compile_env!(:video_streamer, :port)

  @impl Application
  def start(_, _) do
    args = [
      metrics: metrics(),
      port: @port
    ]

    opts = ensure_options(args)

    children = [
      {TelemetryMetricsPrometheus.Core, opts},
      {Video.Streamer, opts}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp ensure_options(options) do
    {port, updated_opts} =
      Keyword.merge(default_options(), options)
      |> Keyword.pop(:port)

    Keyword.delete(updated_opts, :plug_cowboy_opts)
    |> Keyword.update!(:options, fn opts ->
      Keyword.merge(opts, Keyword.get(options, :plug_cowboy_opts, []))
      |> Keyword.put(:port, port)
      |> Keyword.put_new(:ref, Keyword.get(updated_opts, :name))
    end)
  end

  defp default_options() do
    [
      protocol: :http,
      name: :prometheus_metrics,
      options: []
    ]
  end

  @spec metrics() :: [Telemetry.Metrics.t()]
  def metrics,
    do: [
      Telemetry.Metrics.counter("video.metrics.watched", tags: [:file])
    ]
end
