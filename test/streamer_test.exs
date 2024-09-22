defmodule Video.StreamerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Video.Streamer.init([])

  test "GET /video returns video file" do
    # Prepare the simulated connection
    conn = conn(:get, "/video")

    # Call the router
    conn = Video.Streamer.call(conn, @opts)

    # Assert that the status is 200 (success)
    assert conn.status == 200

    # Optional: Assert response content type is correct
    assert conn.resp_headers
           |> Enum.any?(fn {k, v} ->
             k == "content-type" and
               String.contains?(v, "video/mp4")
           end)
  end
end
