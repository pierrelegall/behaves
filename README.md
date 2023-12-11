[hex-version]: https://hex.pm/packages/behaves
[hex-version-badge]: https://img.shields.io/hexpm/v/behaves.svg
[hex-downloads]: https://hex.pm/packages/behaves
[hex-downloads-badge]: https://img.shields.io/hexpm/dt/behaves.svg
[mit-license]: https://opensource.org/licenses/MIT
[mit-license-badge]: https://img.shields.io/badge/license-MIT-blue.svg
[behaviours-doc]: https://hexdocs.pm/elixir/1.15.7/typespecs.html#behaviours

# Behaves

[![Hex Version][hex-version-badge]][hex-version]
[![Hex Downloads][hex-downloads-badge]][hex-downloads]
[![License][mit-license-badge]][mit-license]

`Behaves` can help you if you need to check Elixir modules
[behaviours](behaviours-doc) at runtime.

Elixir warns at compile-time when you haven't implemented the required functions
in a behaviour's implementation. However, there is no elegant built-in way to know
whether or not a given module implements another module's behaviour at runtime.
`Behaves` tries to solve this problem.

## How to use

Given the following modules definition:

```elixir
defmodule Parser do
  @callback parse(String.t()) :: {:ok, map()} | {:error, String.t()}
end

defmodule JSONParser do
  @behaviour Parser

  @impl Parser
  def parse(json) do
    # ...
  end
end
```

`Behaves` can help you to check if `JSONParser` implements the `Parser` behaviour at runtime
in different ways (with `like_a?/2`, `like_a/2`, `like_a!/2` or `like_a/1`):

```elixir
JSONParser
|> Behaves.like_a?(Parser)
# => true

JSONParser
|> Behaves.like_a(Parser)
# => :ok

JSONParser
|> Behaves.like_a!(Parser)
# => :ok

JSONParser
|> Behaves.like_a()
# => [Parser]
```

The returned value informs you of the situation in case of a non-positive check:

```elixir
Supervisor
|> Behaves.like_a?(Parser)
# => false

Superviour
|> Behaves.like_a(NotAModule)
# => {:not_a_module, NotAModule}

NotAModule
|> Behaves.like_a(Parser)
# => {:not_a_module, NotAModule}

Supervisor
|> Behaves.like_a(File)
# => {:not_a_behaviour, File}

Supervisor
|> Behaves.like_a(Parser)
# => {:not_implemented, Parser}

NotAModule
|> Behaves.like_a!(File)
# ** (ArgumentError) given implementation NotAModule is not a module
#     (behaves 0.1.0) lib/behaves.ex:89: Behaves.like_a!/2
#     iex:23: (file)

Supervisor
|> Behaves.like_a!(NotAModule)
# ** (ArgumentError) given behaviour NotAModule is not a module
#     (behaves 0.1.0) lib/behaves.ex:86: Behaves.like_a!/2
#     iex:23: (file)

Supervisor
|> Behaves.like_a!(File)
# ** (ArgumentError) given behaviour File is not a behaviour
#     (behaves 0.1.0) lib/behaves.ex:83: Behaves.like_a!/2
#     iex:23: (file)

Supervisor
|> Behaves.like_a!(Parser)
# ** (Behaves.NotImplementedError) Supervisor does not implement Parser
#     (behaves 0.1.0) lib/behaves.ex:80: Behaves.like_a!/2
#     iex:24: (file)

Supervisor
|> Behaves.like_a()
# => []

NotAModule
|> Behaves.like_a()
# => {:not_a_module, NotAModule}
```

## Installation

Behaves can be installed by adding the line below in your Mix dependencies:

```elixir
def deps do
  [
    {:behaves, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/behaves](https://hexdocs.pm/behaves).

## Tests

Tested with Elixir `1.15.7` (should be fine from `1.9`) and Erlang/OTP `26.1.2`.

## Inspiration

Inspired by [behave](https://github.com/DoggettCK/behave), but `Behaves` has more
features. Moreover, it has a better API considering `A |> Behaves.like_a(B)`
better than `Behave.behaviour_implemented?(A, B)`.
