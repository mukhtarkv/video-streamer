defmodule Video.MixProject do
  use Mix.Project

  def project do
    [
      app: :video_streamer,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        video_streamer: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          strip_beams: false
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Video.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.7"}
    ]
  end
end