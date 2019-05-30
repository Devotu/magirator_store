defmodule MagiratorStore.MixProject do
  use Mix.Project

  def project do
    [
      app: :magirator_store,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MagiratorStore.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bolt_sips, "~> 1.5"},
      {:ecto, "~> 3.0"},
    ]
  end
end
