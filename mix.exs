defmodule Slack.MixProject do
  use Mix.Project

  def project do
    [
      app: :slack,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Docs
      name: "Slack",
      source_url: "https://github.com/petlove/slack_elixir",
      docs: [main: "Slack", extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.2"}
    ]
  end
end
