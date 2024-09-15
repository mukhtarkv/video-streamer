defmodule Video.Application do
  use Application

  @impl Application
  def start(_, _) do
    children = [
      Video.Streamer
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
