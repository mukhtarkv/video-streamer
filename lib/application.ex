defmodule Video.Application do
  use Application

  @impl Application
  def start(_, _) do
    Video.Metrics.setup()

    children = [
      Video.Streamer
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
