defmodule Behaves.MixProject do
  use Mix.Project

  def project do
    [
      name: "Behaves",
      app: :behaves,
      version: "0.1.0",
      description: "An helper to check Elixir modules behaviours at runtime.",
      source_url: "https://github.com/pierrelegall/behaves",
      homepage_url: "https://github.com/pierrelegall/behaves",
      elixir: "~> 1.9",
      deps: deps(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.2", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30.9", only: [:dev], runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: ["Pierre Le Gall"],
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      links: %{"GitHub" => "https://github.com/pierrelegall/behaves"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
