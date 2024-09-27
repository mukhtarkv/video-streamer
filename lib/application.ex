defmodule Video.Application do
  use Application

  @impl Application
  def start(_, _) do
    children = [
      {TelemetryMetricsPrometheus, [metrics: metrics()]},
      Video.Streamer
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def metrics,
    do: [
      Telemetry.Metrics.counter("video.metrics.watched", tags: [:file])
    ]
end
