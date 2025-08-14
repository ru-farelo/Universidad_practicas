defmodule Easycurt.MixProject do
  use Mix.Project

  def project do
    [
      app: :easycurt,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "Easycourt",
        extras: ["README.md"],
        source_url: "https://github.com/xoelpenass/AS-paralelo/tree/main/easycourt"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end
end
