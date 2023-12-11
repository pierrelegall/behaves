defmodule Behaves do
  @moduledoc """
  `Behaves` allows you to check if an Elixir module implements a given
  [behaviour](https://elixir-lang.org/getting-started/typespecs-and-behaviours.html).
  """

  defmodule NotImplementedError do
    defexception [:message]
  end

  @doc """
  Returns the list of behaviours implemented by `impl`.

  Behaviours are sorted in the same order of `@behaviour`s defined in the `impl` module.
  """
  @spec like_a(impl :: atom()) ::
          list(module())
  def like_a(impl) when is_atom(impl) do
    cond do
      not module?(impl) ->
        []

      true ->
        get_behaviours(impl)
    end
  end

  @doc """
  Returns `:ok` if the `impl` implements the behaviour.

  In other cases, returns:
  - `{:not_implemented, {impl, behaviour}}` if the implementation dos not implements the behaviour
  - `{:not_a_module, impl}` if `impl` is not a module
  - `{:not_a_module, behaviour}` if `behaviour` is not a module
  - `{:not_a_behaviour, behaviour}` if `behaviour` is not a behaviour
  """
  @spec like_a(impl :: atom(), behaviour :: atom()) ::
          :ok
          | {:not_implemented, {module(), module()}}
          | {:not_a_behaviour, module()}
          | {:not_a_module, atom()}
  def like_a(impl, behaviour)
      when is_atom(impl) and is_atom(behaviour) do
    cond do
      not module?(impl) ->
        {:not_a_module, impl}

      not module?(behaviour) ->
        {:not_a_module, behaviour}

      not behaviour?(behaviour) ->
        {:not_a_behaviour, behaviour}

      true ->
        case has_behaviour?(impl, behaviour) do
          false -> {:not_implemented, {impl, behaviour}}
          true -> :ok
        end
    end
  end

  @doc """
  Returns `:ok` if a given `impl` implements the `behaviour` or raises.

  Possible raised errors are:
  - `ArgumentError` if `impl` is not a module
  - `ArgumentError` if `behaviour` is not a module
  - `Behaves.NotImplementedError` if `impl` does not implement the `behaviour`
  """
  @spec like_a!(impl :: atom(), behaviour :: atom()) :: :ok
  def like_a!(impl, behaviour)
      when is_atom(impl) and is_atom(behaviour) do
    case like_a(impl, behaviour) do
      :ok ->
        :ok

      {:not_implemented, _} ->
        raise NotImplementedError, "#{inspect(impl)} does not implement #{inspect(behaviour)}"

      {:not_a_behaviour, _} ->
        raise ArgumentError, "given behaviour #{inspect(behaviour)} is not a behaviour"

      {:not_a_module, ^behaviour} ->
        raise ArgumentError, "given behaviour #{inspect(behaviour)} is not a module"

      {:not_a_module, ^impl} ->
        raise ArgumentError, "given implementation #{inspect(impl)} is not a module"
    end
  end

  @doc """
  Returns `true` if `impl` implements the `behaviour` or `false` if it does not.
  """
  @spec like_a?(impl :: atom(), behaviour :: atom()) :: boolean()
  def like_a?(impl, behaviour)
      when is_atom(impl) and is_atom(behaviour) do
    cond do
      not module?(impl) ->
        false

      true ->
        has_behaviour?(impl, behaviour)
    end
  end

  defp module?(module) do
    case Code.ensure_loaded(module) do
      {:module, ^module} -> true
      _ -> false
    end
  end

  defp behaviour?(module) do
    module.module_info(:exports)
    |> Enum.member?({:behaviour_info, 1})
  end

  defp has_behaviour?(module, behaviour) do
    module.module_info(:attributes)
    |> Enum.member?({:behaviour, [behaviour]})
  end

  defp get_behaviours(module) do
    module.module_info(:attributes)
    |> Keyword.take([:behaviour])
    |> Keyword.values()
    |> Enum.map(&List.first(&1))
  end
end
