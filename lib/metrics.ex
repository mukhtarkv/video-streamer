defmodule Video.Metrics.PrometheusExporter do
  use Prometheus.PlugExporter
end

defmodule Video.Metrics do
  use Prometheus.Metric

  @counter name: :views_total, labels: [:cartoon], help: "Total view times"

  def setup() do
    Video.Metrics.PrometheusExporter.setup()
  end

  def viewed(label \\ :cartoon) do
    Counter.inc(
      name: :views_total,
      labels: [label]
    )
  end
end
