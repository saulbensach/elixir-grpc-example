defmodule Example.MixProject do
  use Mix.Project

  def project do
    [
      app: :example,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Example.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:protobuf, "~> 0.7.1"},
      {:grpc, github: "elixir-grpc/grpc", tag: "v0.4.0"},
      {:cowboy, "~> 2.5",
       git: "https://github.com/elixir-grpc/cowboy.git", tag: "grpc-2.6.3", override: true},
      {:ranch, "~> 1.7", override: true},
      {:broadway, "~> 0.6.0"},
      {:poolboy, "~> 1.5"}
    ]
  end
end
