defmodule Video.Metrics do
  def viewed(file) do
    :telemetry.execute(
      [:video, :metrics],
      %{
        watched: 1
      },
      %{file: file}
    )
  end
end
