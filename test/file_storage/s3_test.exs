defmodule Video.FileStorage.S3Test do
  use ExUnit.Case, async: true
  import Mox

  alias Video.FileStorage.S3

  setup :verify_on_exit!

  setup do
    Process.flag(:trap_exit, true)
    :ok
  end

  test "stream_file/1" do
    HttpClientMock
    |> expect(:request, fn :head, url, _body, _headers, _options ->
      assert url == "https://s3.amazonaws.com/test-videos/cool_video.mp4"
      {:ok, %{status_code: 200, body: "", headers: [{"content-length", "100"}]}}
    end)

    HttpClientMock
    |> expect(:request, fn :get, url, _body, headers, _options ->
      assert Enum.any?(headers, fn {k, v} -> k == "range" and v == "bytes=0-99" end)
      assert url == "https://s3.amazonaws.com/test-videos/cool_video.mp4"
      {:ok, %{status_code: 200, body: "fake_video_data"}}
    end)

    path = "cool_video.mp4"

    {:ok, stream} = S3.stream_file(path)

    assert stream |> Enum.to_list() == ["fake_video_data"]
  end

  test "stream_file/1 when head request fails" do
    HttpClientMock
    |> expect(:request, fn :head, url, _body, _headers, _options ->
      assert url == "https://s3.amazonaws.com/test-videos/cool_video.mp4"
      {:ok, %{status_code: 200, body: "", headers: [{"content-length", "100"}]}}
    end)

    HttpClientMock
    |> expect(:request, fn :get, url, _body, headers, _options ->
      assert Enum.any?(headers, fn {k, v} -> k == "range" and v == "bytes=0-99" end)
      assert url == "https://s3.amazonaws.com/test-videos/cool_video.mp4"
      {:ok, %{status_code: 404, body: "fake_video_data"}}
    end)

    path = "cool_video.mp4"

    {:ok, stream} = S3.stream_file(path)

    assert_raise FunctionClauseError, fn ->
      stream |> Enum.to_list()
    end
  end
end
