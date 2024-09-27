defmodule Video.StreamerTest do
  use ExUnit.Case
  use Plug.Test
  import Mox

  @opts Video.Streamer.init([])

  test "GET /video returns video file" do
    ref = :telemetry_test.attach_event_handlers(self(), [[:video, :metrics]])

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

    assert_received {[:video, :metrics], ^ref, %{watched: _}, %{file: _}}
  end
end
