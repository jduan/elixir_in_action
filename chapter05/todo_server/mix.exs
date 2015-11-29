defmodule TodoServer.Mixfile do
  use Mix.Project

  def project do
    [app: :todo_server,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :gproc,
        :cowboy,
        :plug,
      ],
      mod: {Todo.Application, []},
      env: [
        port: 5454,
      ],
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:gproc, "0.5.0"},
      {:cowboy, "1.0.4"},
      {:plug, "1.0.3"},
      {:httpoison, "0.8.0", only: :test},
      {:meck, "0.8.3", only: :test},
    ]
  end
end
