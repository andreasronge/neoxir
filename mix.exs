defmodule Neoxir.Mixfile do
  use Mix.Project

  def project do
    [app: :neoixr,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps, 
     package: package,
     source_url: "https://github.com/andreasronge/neoxir",
     description: "An Elixir driver for the Neo4j Graph Database, see www.neo4j.org"]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [ 
      { :httpoison, "~> 0.8.0"},
      { :exjsx, "~> 3.1"},
      { :meck, "~> 0.8.2", only: :test },
      { :ex_doc, "~> 0.7", only: :docs }
    ]
  end

  defp package do
    %{licenses: ["MIT"],
      links: %{"Github" => "https://github.com/andreasronge/neoxir"}}
  end
end
