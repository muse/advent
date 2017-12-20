defmodule Advent.Mixfile do
  use Mix.Project

  @spec project() :: keyword
  def project do
    [app: :advent,
     version: "0.1.0",
     elixir: "~> 1.5",
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  @spec application() :: []
  defp application, do: []

  @spec deps() :: []
  defp deps, do: []
end
