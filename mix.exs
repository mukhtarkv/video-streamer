defmodule Video.MixProject do
  use Mix.Project

  def project do
    [
      app: :video_streamer,
      version: "0.1.0",
      elixir: "~> 1.16.3",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      elixirc_paths: elixirc_paths(Mix.env()),
      releases: [
        video_streamer: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          strip_beams: false
        ]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
      {:plug_cowboy, "~> 2.7"},
      {:ex_aws, "~> 2.5"},
      {:ex_aws_s3, "~> 2.5"},
      {:hackney, "~> 1.20"},
      {:sweet_xml, "~> 0.6"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.0"},
      {:mox, "~> 1.2", only: :test},
      {:excoveralls, "~> 0.18", only: :test}
    ]
  end
end
