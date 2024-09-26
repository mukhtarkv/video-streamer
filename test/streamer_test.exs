defmodule Video.StreamerTest do
  use ExUnit.Case
  use Plug.Test
  import Mox

  @opts Video.Streamer.init([])

  test "GET /video returns video file" do
    # Prepare the simulated connection
    conn = conn(:get, "/video")

    # Call the router
    conn = Video.Streamer.call(conn, @opts)

    # Assert that the status is 200 (success)
    assert conn.status == 200

    assert conn.resp_headers
           |> Enum.any?(fn {k, v} ->
             k == "content-type" and
               String.contains?(v, "video/mp4")
           end)

    assert Prometheus.Metric.Counter.value(name: :views_total, labels: [:cartoon]) == 1
    conn(:get, "/video") |> Video.Streamer.call(@opts)
    assert Prometheus.Metric.Counter.value(name: :views_total, labels: [:cartoon]) == 2
  end

  test "GET /metrics succeeds" do
    # Prepare the simulated connection
    conn = conn(:get, "/metrics")

    # Call the router
    conn = Video.Streamer.call(conn, @opts)

    # Assert that the status is 200 (success)
    assert conn.status == 200
  end
end
