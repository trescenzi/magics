defmodule Magics.Mixfile do
  use Mix.Project

  def project do
    [app: :magics,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :ibrowse]]
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
    [{:tesla, "~> 0.1.0"},
     {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.1"}, # default adapter
     {:exjsx, "~> 3.1.0"}, # for JSON middleware
     {:floki, "~> 0.3"} # for parsing and quering HTML
    ]
  end
end
