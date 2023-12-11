# Define a test environment for tests

defmodule BehaviourModule do
  @callback run() :: :ok | {:error, String.t()}
end

defmodule AnotherBehaviourModule do
  @callback validate() :: :ok | {:error, String.t()}
end

defmodule BehaviourWihtoutImplModule do
  @callback save() :: :ok | {:error, String.t()}
end

defmodule NotABehaviourModule do
  def greeting() do
    :hello
  end
end

defmodule ImplModule do
  @behaviour BehaviourModule
  @behaviour AnotherBehaviourModule

  @impl BehaviourModule
  def run do
    :ok
  end

  @impl AnotherBehaviourModule
  def validate do
    :ok
  end
end

defmodule NotAnImplModule do
  def install do
    nil
  end
end
